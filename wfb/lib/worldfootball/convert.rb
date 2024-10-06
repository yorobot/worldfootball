
module Worldfootball


def self.convert( league:, season: )
  season = Season( season )  ## cast (ensure) season class (NOT string, integer, etc.)

  league = find_league!( league )
  pages  = league.pages!( season: season )


    ## collect all teams
    teams_by_ref = {}

    recs = []
    pages.each do |slug, stage|
      ## note: stage might be nil
      ## todo/fix: report error/check if stage is nil!!!
      stage ||= ''

      ## try to map stage name if new name defined/found
      unless stage.empty?
         stage_new  =  map_stage( stage, league: league.key,
                                         season: season )
         stage = stage_new  if stage_new
      end


      print "  parsing #{slug}..."

      # unless File.exist?( path )
      #  puts "!! WARN - missing stage >#{stage_name}< source - >#{path}<"
      #  next
      # end

      page = Page::Schedule.from_cache( slug )
      print "  title=>#{page.title}<..."
      print "\n"

      rows = page.matches

      teams = page.teams
      ## e.g. {:count=>2, :name=>"AS Arta", :ref=>"as-arta"},
      ##      {:count=>4, :name=>"Dekedaha FC", :ref=>"dekedaha-fc"},
      ##        ...
      teams.each do |h|
          team_count = h[:count]
          team_name  = norm_team( h[:name] )      ## note: norm team name!!!
          team_ref   = h[:ref]

          ## note: skip N.N.  (place holder team)
          ##        team_ref is nil etc.
          next if team_name == 'N.N.'

          team_stat = teams_by_ref[ team_ref ] ||= { count: 0,
                                                     name:  team_name }
          team_stat[:count] += team_count
          if team_name != team_stat[:name]
              puts "!! ASSERT ERROR - team ref with differet names; expected #{team_stat[:name]} - got #{team_name}"
              exit 1
          end
      end


      stage_recs = build( rows,
                          season: season,
                          league: league.key,
                          stage: stage )

      pp stage_recs[0]   ## check first record
      recs += stage_recs
    end


    clubs_intl  =  ['uefa.cl', 'uefa.el', 'uefa.conf',
                    'copa.l',
                    'caf.cl',
                    'afl'].include?(league.key) ? true : false

    ####
    #   auto-add (fifa) country code if int'l club tournament
    if clubs_intl
 ##
 ##   get country codes for team ref
       teams_by_ref.each do |team_slug, h|

          Metal.download_team( team_slug, cache: true )
          team_page = Page::Team.from_cache( team_slug )
          props = team_page.props
          pp props
          country_name = props[:country]
          cty = Fifa.world.find_by_name( country_name )
          if cty.nil?
            puts "!! ERROR - no country found for #{country_name}"
            exit 1
          end
          h[:code] = cty.code
       end

       ## generate lookup by name
       teams_by_name = teams_by_ref.reduce( {} ) do |h, (slug,rec)|
            h[ rec[:name]] = rec
            h
       end

    #####
    ## dump team refs
    puts "  #{teams_by_ref.size} team(s) by ref:"
    pp teams_by_name

    ## quick hack
    ##  add country (fifa) codes to team names
        recs.each do |rec|
           team1_org  =  rec[5]
           if team1_org != 'N.N.'   ## note - skip place holder; keep as-is
             country_code = teams_by_name[team1_org][:code]
             rec[5]  = "#{team1_org} (#{country_code})"
           end

           team2_org = rec[8]
           if team2_org != 'N.N.'   ## note - skip place holder; keep as-is
             country_code = teams_by_name[team2_org][:code]
             rec[8]  = "#{team2_org} (#{country_code})"
           end
        end
    end


##   note:  sort matches by date before saving/writing!!!!
##     note: for now assume date in string in 1999-11-30 format (allows sort by "simple" a-z)
## note: assume date is third column!!! (stage/round/date/...)
recs = recs.sort { |l,r| l[2] <=> r[2] }
## reformat date / beautify e.g. Sat Aug 7 1993
recs.each do |rec|
         rec[2] = Date.strptime( rec[2], '%Y-%m-%d' ).strftime( '%a %b %-d %Y' )
       end

   ## remove unused columns (e.g. stage, et, p, etc.)
   recs, headers = vacuum( recs )

   puts headers
   pp recs[0]   ## check first record

   out_path = "#{config.convert.out_dir}/#{season.path}/#{league.key}.csv"

   puts "write #{out_path}..."
   write_csv( out_path, recs, headers: headers )
end
end # module Worldfootball

