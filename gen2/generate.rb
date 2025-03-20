####
#  to run use:
#     $ ruby gen2/generate.rb


$LOAD_PATH.unshift( '/sports/sportdb/sport.db/timezones/lib' )
$LOAD_PATH.unshift( '/sports/sportdb/sport.db/fifa/lib' )
$LOAD_PATH.unshift( './wfb/lib' )
require 'worldfootball'


Webcache.root =  if File.exist?( '/sports/cache' )
                     puts "  setting web cache to >/sports/cache<"
                     '/sports/cache'
                 else
                     './cache'
                 end

## convert (default) output directory
Worldfootball.config.convert.out_dir = if File.exist?( '/sports/cache.wfb')
                                           puts "  setting convert out_dir to >/sports/cache.wfb<"
                                           '/sports/cache.wfb'
                                        else
                                           './tmp' ## use tmp in working dir
                                        end

Worldfootball.config.generate.out_dir =  './gen2/o' ## use tmp in working dir
                                        




module Worldfootball
def self.generate2( league:, season:,
                   overwrite: true )
   season = Season( season )  ## cast (ensure) season class (NOT string, integer, etc.)

   league = find_league!( league )
   pages  = league.pages!( season: season )

###
#  get league title from (cached) page
    pp pages

    slug = pages[0][0]
    page = Worldfootball::Page::Schedule.from_cache( slug )

    league_name = page.title
    pp league_name 


   out_path = "#{config.generate.out_dir}/#{league.key}/#{season.to_path}_#{league.key}.txt"

   ## check if output exists already
   if !overwrite && File.exist?( out_path )
     ## skip generation
     puts "  OK #{league.key} #{season}   (do NOT overwrite)"
     return
   end


   ## get matches
   path = "#{config.convert.out_dir}/#{season.to_path}/#{league.key}.csv"
   puts "  ---> reading matches in #{path} ..."
   matches = SportDb::CsvMatchParser.read( path )
   puts "     #{matches.size} matches"

   ## build
   txt = SportDb::TxtMatchWriter.build( matches )
   ## puts txt


   buf = String.new
   ## note - use league key for league name for now!!
   ##   todo/fix - use league name from page itself
   buf << "= #{league.key.upcase.gsub('.', ' ')} #{season.key}\n\n"
   buf << txt

   puts "   writing to >#{out_path}<..."
   write_text( out_path, buf )
end
end   # module Worldfootball




# league = 'mls'
# seasons =  ['2022', '2023', '2024', '2025']

league = 'mx.1'
seasons =  ['2023/24', '2024/25']


seasons.each do |season|
    Worldfootball.generate2( league: league, season: season )
end   


puts "bye"


__END__

{"mx.1"=>
  {"2023/24"=>
    {:names=>
      ["Primera División 2023/2024 Apertura » Spielplan",
       "Primera División 2023/2024 Apertura Playoffs » Spielplan",
       "Primera División 2023/2024 Clausura » Spielplan",
       "Primera División 2023/2024 Clausura Playoffs » Spielplan"]},
   "2024/25"=>
    {:names=>
      ["Primera División 2024/2025 Apertura » Spielplan",
       "Primera División 2024/2025 Apertura Playoffs » Spielplan",
       "Primera División 2024/2025 Clausura » Spielplan"]}}}


