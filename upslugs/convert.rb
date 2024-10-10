##########
#  to run use:
#   $ ruby upslugs/convert.rb


require_relative 'helper'


Webget.config.sleep = 2



def convert( league:, season: )
   ## skip if already converted
   season_path = Season( season ).path
   league_key  = league
   out_path = "#{Worldfootball.config.convert.out_dir}/#{season_path}/#{league_key}.csv"
   if File.exist?( out_path )
     ## skip
     puts "  OK #{league} #{season}"
   else
     Worldfootball.convert( league: league, season: season )
   end
end # method convert




keys = Worldfootball::LEAGUES.keys




keys.each_with_index do |key, i|

  league = Worldfootball::LEAGUES[key]

  seasons = league.seasons

  puts "==> #{i+1}/#{keys.size} #{key} - #{seasons.size} seasons(s)..."

  seasons.each_with_index do |season_rec,j|
    season = season_rec[0]

    puts "  #{j+1}/#{seasons.size} #{key} #{season}..."
    convert( league: key, season: season )
  end
end


puts "bye"
