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


=begin
league_name = 'Major League Soccer'
league = 'mls'
# seasons =  %w[2005 2006]    ##[2022 2023 2024 2025]
seasons  = %w[2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 2020 2021 2022 2023 2024 2025]
league_path = 'north-america/major-league-soccer'
=end
# world/north-america/major-league-soccer/2005_mls.txt

=begin
league_name = 'Israel | Premier League'
league      = 'il.1'
seasons     = %w[2023/24 2024/25]
league_path = 'middle-east/israel'
=end


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


recs = read_csv( "./gen2/world.csv" )


recs.each_with_index do |rec,i|
  puts "==> #{i+1}/#{recs.size}"
  pp rec

  league      = rec['league']
  league_name = rec['league_name']
  league_path = rec['league_path']

  seasons     = rec['seasons'].split( /[ ]+/ )
  pp seasons

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


{"il.1"=>
  {"2023/24"=>
    {:names=>
      ["Ligat ha'Al 2023/2024 » Spielplan",
       "Ligat ha'Al 2023/2024 Championship » Spielplan",
       "Ligat ha'Al 2023/2024 Relegation » Spielplan"]},
   "2024/25"=>
    {:names=>
      ["Ligat ha'Al 2024/2025 » Spielplan",
       "Ligat ha'Al 2024/2025 Championship » Spielplan",
       "Ligat ha'Al 2024/2025 Relegation » Spielplan"]}}}   

{"jp.1"=>
  {"2019"=>{:names=>["J1 League 2019 » Spielplan"]},
   "2020"=>{:names=>["J1 League 2020 » Spielplan"]},
   "2021"=>{:names=>["J1 League 2021 » Spielplan"]},
   "2022"=>{:names=>["J1 League 2022 » Spielplan"]},
   "2023"=>{:names=>["J1 League 2023 » Spielplan"]},
   "2024"=>{:names=>["J1 League 2024 » Spielplan"]},
   "2025"=>{:names=>["J1 League 2025 » Spielplan"]}},
 "cn.1"=>
  {"2018"=>{:names=>["Super League 2018 » Spielplan"]},
   "2019"=>{:names=>["Super League 2019 » Spielplan"]},
   "2020"=>
    {:names=>
      ["Super League 2020 » Spielplan",
       "Super League 2020 Playoffs » Spielplan",
       "Super League 2020 Relegation » Spielplan"]},
   "2021"=>
    {:names=>
      ["Super League 2021 » Spielplan",
       "Super League 2021 Playoffs » Spielplan",
       "Super League 2021 Relegation » Spielplan"]},
   "2022"=>{:names=>["Super League 2022 » Spielplan"]},
   "2023"=>{:names=>["Super League 2023 » Spielplan"]},
   "2024"=>{:names=>["Super League 2024 » Spielplan"]},
   "2025"=>{:names=>["Super League 2025 » Spielplan"]}},
 "kz.1"=>
  {"2023"=>{:names=>["Premier Liga 2023 » Spielplan"]},
   "2024"=>{:names=>["Premier Liga 2024 » Spielplan"]},
   "2025"=>{:names=>["Premier Liga 2025 » Spielplan"]}}}

{"eg.1"=>
  {"2023/24"=>{:names=>["Premiership 2023/2024 » Spielplan"]},
   "2024/25"=>
    {:names=>
      ["Premiership 2024/2025 » Spielplan",
       "Premiership 2024/2025 Championship » Spielplan",
       "Premiership 2024/2025 Relegation » Spielplan"]}},
 "ma.1"=>
  {"2023/24"=>{:names=>["Botola Pro 1 2023/2024 » Spielplan"]},
   "2024/25"=>{:names=>["Botola Pro 1 2024/2025 » Spielplan"]}},
 "dz.1"=>
  {"2023/24"=>{:names=>["Ligue 1 2023/2024 » Spielplan"]}, "2024/25"=>{:names=>["Ligue 1 2024/2025 » Spielplan"]}}}