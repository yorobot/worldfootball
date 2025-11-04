
module Worldfootball


def self.convert( league:, season:,
                  overwrite: true )
  season = Season( season )  ## cast (ensure) season class (NOT string, integer, etc.)

  league = find_league!( league )
  pages  = league.pages!( season: season )


  out_path = "#{config.convert.out_dir}/#{season.path}/#{league.key}.csv"
  if !overwrite && File.exist?( out_path )
    ## skip generation
    puts "  OK #{league.key} #{season}   (do NOT overwrite)"
    return
  end



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
      ###   {:count=>2, :name=>"Arsenal / Real Madrid", :ref=>nil},
      ##   {:count=>2, :name=>"PSG / Aston Villa", :ref=>nil},
      ##   {:count=>2, :name=>"Barcelona / Dortmund", :ref=>nil},
      ##   {:count=>2, :name=>"Bayern / Inter", :ref=>nil},
      ##   {:count=>1, :name=>"Sieger HF 1", :ref=>nil},
      ##  {:count=>1, :name=>"Sieger HF 2", :ref=>nil}]


      teams.each do |h|
          team_count = h[:count]
          team_name  = norm_team( h[:name] )      ## note: norm team name!!!
          team_ref   = h[:ref]

###
##   quick fix for broken refs/links
##    olympique-lyon => olympique-lyonnais
       #   team_ref = 'olympique-lyonnais'   if team_ref == 'olympique-lyon'

          ## note: skip N.N.  (place holder team)
          ##        team_ref is nil etc.
          next if team_name == 'N.N.'
          ### warn if team_ref is nil and skip !!!
          next if team_ref.nil?
      
          
          team_stat = teams_by_ref[ team_ref ] ||= { count: 0,
                                                     names:  [] }
          team_stat[:count] += team_count
          team_stat[:names] << team_name   unless team_stat[:names].include?( team_name )
      end


      stage_recs = build( rows,
                          season: season,
                          league: league.key,
                          stage: stage )

      pp stage_recs[0]   ## check first record
      recs += stage_recs
    end


    clubs_intl  =  ['uefa.cl', 'uefa.el', 'uefa.conf',
                    'uefa.cl.q', 'uefa.el.q', 'uefa.conf.q',
                     'copa.l', 'copa.s',
                    'concacaf.cl',
                    'caf.cl',
                    'afl',
                    'world.clubs',   ## club worldcup
                  ].include?(league.key) ? true : false

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
  ### todo/fix
  ##    report warning if names size is > 1!!!!
  ##
             rec[:names].each do |name|
                h[ name ] = rec
              end
              h
       end


    #####
    ## dump team refs
    puts "  #{teams_by_ref.size} team(s) by ref:"
    pp teams_by_ref

    ## quick hack
    ##  add country (fifa) codes to team names
    ##
    ##  note - some placeholder teams have no ref!! and, thus no entry with country code
        recs.each do |rec|
           team1_org  =  rec[5]
           if team1_org != 'N.N.' &&  ## note - skip place holder; keep as-is
              teams_by_name[team1_org]
             country_code = teams_by_name[team1_org][:code]
             rec[5]  = "#{team1_org} (#{country_code})"
           end

           team2_org = rec[8]
           if team2_org != 'N.N.' &&   ## note - skip place holder; keep as-is
              teams_by_name[team2_org]
             country_code = teams_by_name[team2_org][:code]
             rec[8]  = "#{team2_org} (#{country_code})"
           end
        end
    end


##   note:  sort matches by date before saving/writing!!!!
##     note: for now assume date in string in 1999-11-30 format (allows sort by "simple" a-z)
## note: assume date is third column!!! (stage/round/date/...)

### note - do NOT sort for now
##    keep "original" page order - why? why not?
## recs = recs.sort { |l,r| l[2] <=> r[2] }


## reformat date / beautify e.g. Sat Aug 7 1993
recs.each do |rec|
            if rec[2]
              if rec[2] =~ /^\d{4}-\d{1,2}-\d{1,2}$/
               rec[2] = Date.strptime( rec[2], '%Y-%m-%d' ).strftime( '%a %b %-d %Y' )
              else
                ## report unknown date format warning
                puts "WARN - unsupported date format (cannot parse?) >#{rec[2]}<"
              end
            end
       end

   ## remove unused columns (e.g. stage, et, p, etc.)
   recs, headers = vacuum( recs )

   puts headers
   pp recs[0]   ## check first record

   puts "   writing to >#{out_path}< - #{recs.size} record(s)..."
   write_csv( out_path, recs, headers: headers )

   ## add to tmp too for debugging
   out_path2 = "#{config.convert.out_dir}/tmp/#{league.key}/#{season.to_path}.csv"
   puts "   writing to >#{out_path2}< - #{recs.size} record(s)..."
   write_csv( out_path2, recs, headers: headers )
end
end # module Worldfootball

