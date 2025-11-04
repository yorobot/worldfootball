

module Worldfootball
class LeagueConfig
def initialize
  @table = {}
end

class LeagueItem  # nested inside LeagueConfig
  attr_reader :key, :slug

  def initialize( key:, slug: )
    @key  = key
    @slug = slug

    @seasons  = nil
  end


  def seasons
     ## auto-(down)load on first request

     @seasons ||= begin
       ### todo/fix:
       ##     use from cache if not older than 1 (or 5/10?) hour(s) or such
       ##           why? why not?
       schedule_url = Worldfootball::Metal.schedule_url( @slug )
       if Webcache.expired_in_1d?( schedule_url )
         Worldfootball::Metal.download_schedule( @slug )
       end
       page = Worldfootball::Page::Schedule.from_cache( @slug )

     ## pp page.seasons
=begin
[{:text=>"2024/2025", :ref=>"aut-oefb-cup-2024-2025"},
 {:text=>"2023/2024", :ref=>"aut-oefb-cup-2023-2024"},
 {:text=>"2022/2023", :ref=>"aut-oefb-cup-2022-2023"},
 {:text=>"2021/2022", :ref=>"aut-oefb-cup-2021-2022"},
=end

     recs = page.seasons.map { |rec| [rec[:text], rec[:ref]] }
     pp recs
     puts "  #{recs.size} record(s)"
     recs

     seasons = {}
     ## generate lookup table by season
     recs.each do |text,slug|

##
##  fix upstream?? - allow multi-year seasons? why? why not?
##     for now ignore special case and collect more real-world cases/samples
##             if possible
##      ["2019-2021 Playoffs", "regionalliga-bayern-2019-2021-playoffs"],
##      ["2019-2021", "regionalliga-bayern-2019-2021"],
##
##
##   ["1955/1958", "europa-league-1955-1958"]]
##   ["1958/1960", "uefa-cup-1958-1960"],

        season, stage = text.split( ' ', 2 )

## todo/fix: add a waring here and auto log to logs.txt!!!!
        if ['2019-2021',
            '1958/1960',
            '1955/1958'  ].include?( season )
           log( "!! WARN - seasons for league #{@key} incl. invalid season #{season} - slug #{slug}; skipping season" )
           next   ## note - skip invalid season entry
        end
#### quick fix typos:  e.g. 2024/20225  => 2025     in bg.1
        season = season.sub( '20225', '2025' )


        season = Season.parse( season )

        seasons[ season.key ] ||= []
        seasons[ season.key] << [slug, stage]
     end
     seasons
    end
    @seasons
  end


  def pages!( season: )
    pages = pages( season: season )
    if pages.nil?
       puts "!! ERROR - no season #{season} found for #{key}; seasons incl:"
       puts seasons.keys.join( ', ' )
       puts "  #{seasons.keys.size} season(s)"
       exit 1
    end
    pages
  end

  def pages( season: )
    ### lookup league pages/slugs by season
    season = Season( season )

    ## note: assume reverse chronological order
    ##           reverse here
    ##  e.g.
    ##   [["aut-bundesliga-2023-2024-qualifikationsgruppe", "Qualifikationsgruppe"],
    ##    ["aut-bundesliga-2023-2024-playoff", "Playoff"],
    ##    ["aut-bundesliga-2023-2024-meistergruppe", "Meistergruppe"],
    ##    ["aut-bundesliga-2023-2024", nil]]
    ##   =>
    ##   [["aut-bundesliga-2023-2024", nil],
    ##     ["aut-bundesliga-2023-2024-meistergruppe", "Meistergruppe"],
    ##     ["aut-bundesliga-2023-2024-playoff", "Playoff"],
    ##     ["aut-bundesliga-2023-2024-qualifikationsgruppe", "Qualifikationsgruppe"]]
    recs = seasons[season.key]
    recs ?  recs.reverse : nil
  end

  def log( msg )  ### append to log
    File.open( './logs.txt', 'a:utf-8' ) do |f|
      f.write( msg )
      f.write( "\n" )
    end
  end
end # class LeagueItem


def add( recs )
   recs.each do |rec|
      @table[ rec['key'] ] = LeagueItem.new( key: rec['key'],
                                             slug: rec['slug'] )
   end
end

def [](key)  @table[key.to_s.downcase]; end
def keys()   @table.keys; end
def size()   @table.size; end
end # class LeagueConfig




LEAGUES = LeagueConfig.new
['africa',
 'america',
 'asia',
 'europe',
 'middle_east',
 'pacific',
 'world'].each do |name|
  recs = read_csv( "#{Worldfootball.root}/config/leagues/#{name}.csv" )
  pp recs
  puts "   #{recs.size} league(s) in #{name}"
  LEAGUES.add( recs )
end


###########
#  (strict) lookup convenience helpers with error reporting
#              AND abort if no lookup found
def self.find_league!( league_code )
  league = LEAGUES[ league_code ]
  if league.nil?
     puts "!! ERROR - no config found for #{league_code}; leagues incl:"
     puts LEAGUES.keys.join( ', ' )
     puts "  #{LEAGUES.size} leagues(s)"
     exit 1
  end
  league
end

def self.find_league_pages!( league:, season: )
  league = find_league!( league )
  pages  = league.pages!( season: season )
  pages
end
end  # module Worldfootball

