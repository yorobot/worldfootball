##########
#  to run use:
#   $ ruby upslugs/generate.rb


require_relative 'helper'


Webget.config.sleep = 2


##
##  fix - move upstream to generate
##          overwrite/force: false  - why? why not?
##             same for convert !!!

def generate( league:, season: )
   ## skip if already converted
   season  = Season( season )
   league_key  = league

   out_path =  if season >= Season( '2000' )
             "#{Worldfootball.config.generate.out_dir}/#{season.to_path}/#{league_key}.txt"
           else
             decade = season.start_year - (season.start_year%10)
             ## use archive-style before 2000!!!
             "#{Worldfootball.config.generate.out_dir}/archive/#{decade}s/#{season.to_path}/#{league_key}.txt"
           end

   if File.exist?( out_path )
     ## skip
     puts "  OK #{league} #{season}"
   else
     Worldfootball.generate( league: league, season: season )
   end
end # method convert




keys = Worldfootball::LEAGUES.keys[0,3]




keys.each_with_index do |key, i|

  league = Worldfootball::LEAGUES[key]

  seasons = league.seasons

  puts "==> #{i+1}/#{keys.size} #{key} - #{seasons.size} seasons(s)..."

  seasons.each_with_index do |season_rec,j|
    season = season_rec[0]

    puts "  #{j+1}/#{seasons.size} #{key} #{season}..."
    generate( league: key, season: season )
  end
end


puts "bye"
