##########
#  to run use:
#   $ ruby upslugs/generate.rb


require_relative 'helper'


Webget.config.sleep = 2




keys = Worldfootball::LEAGUES.keys[0,3]




keys.each_with_index do |key, i|

  league = Worldfootball::LEAGUES[key]

  seasons = league.seasons

  puts "==> #{i+1}/#{keys.size} #{key} - #{seasons.size} seasons(s)..."

  seasons.each_with_index do |season_rec,j|
    season = season_rec[0]
    next if key == 'nl.cup' && season == '1959/60'

    puts "  #{j+1}/#{seasons.size} #{key} #{season}..."

    Worldfootball.generate( league: key, season: season, overwrite: true )
  end
end


puts "bye"
