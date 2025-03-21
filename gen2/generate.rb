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
                    outpath:,
                   name:,
                   overwrite: true )
   season = Season( season )  ## cast (ensure) season class (NOT string, integer, etc.)

   league = find_league!( league )
   pp league

   pages  = league.pages!( season: season )

###
#  get league title from (cached) page
    pp pages

   ## check if output exists already
   if !overwrite && File.exist?( outpath )
     ## skip generation
     puts "  OK #{league.key} #{season}   (do NOT overwrite)"
     return
   end


   ## get matches
   path = "#{config.convert.out_dir}/#{season.to_path}/#{league.key}.csv"
   puts "  ---> reading matches in #{path} ..."
   matches = SportDb::CsvMatchParser.read( path )
   puts "     #{matches.size} matches"


   ## build & write out
   puts "   writing to >#{outpath}<..."
   SportDb::TxtMatchWriter.write_v2( outpath, matches,
                                      name: name )
end
end   # module Worldfootball



league_name = 'Major League Soccer'
league = 'mls'
seasons =  %w[2005 2006]    ##[2022 2023 2024 2025]
league_path = 'north-america/major-league-soccer'

# world/north-america/major-league-soccer/2005_mls.txt



=begin
league_name  = 'Australia | A-League'
league = 'au.1'
seasons = %w[2018/19 2019/20 2020/21 2021/22 2022/23 2023/24 2024/25]
league_path  = 'pacific/australia' 
=end

# league = 'mx.1'
# seasons =  ['2023/24', '2024/25']

#  world/pacific/australia/2018-19_au1.txt


# rootdir = "./gen2/o"
rootdir = "/sports/openfootball/world"

seasons.each do |season|
    
   outpath = "#{rootdir}"
   outpath += "/#{league_path}"
   outpath += "/#{Season(season).to_path}_"  ## e.g. 2024-25 
   outpath += "#{league.gsub('.', '')}"      ## au.1 to au1
   outpath += ".txt"


    Worldfootball.generate2( league: league, season: season,
                             name: "#{league_name} #{season}",
                             outpath: outpath )
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



{"au.1"=>
  {"2018/19"=>{:names=>["A-League 2018/2019 » Spielplan", "A-League 2018/2019 Finals » Spielplan"]},
   "2019/20"=>{:names=>["A-League 2019/2020 » Spielplan", "A-League 2019/2020 Finals » Spielplan"]},
   "2020/21"=>{:names=>["A-League 2020/2021 » Spielplan", "A-League 2020/2021 Finals » Spielplan"]},
   "2021/22"=>{:names=>["A-League 2021/2022 » Spielplan", "A-League 2021/2022 Finals » Spielplan"]},
   "2022/23"=>{:names=>["A-League 2022/2023 » Spielplan", "A-League 2022/2023 Finals » Spielplan"]},
   "2023/24"=>{:names=>["A-League 2023/2024 » Spielplan", "A-League 2023/2024 Finals » Spielplan"]},
   "2024/25"=>{:names=>["A-League 2024/2025 » Spielplan", "A-League 2024/2025 Finals » Spielplan"]}}}
