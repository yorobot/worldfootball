##########
#  to run use:
#   $ ruby upslugs/max.rb


require_relative 'helper'


##
##  note - filter broken slugs/pages!!!!
##  quick hack for broken pages - exclude for now
##  [cache] saving /alle_spiele/ned-knvb-beker-1959-1960.html...
##  !!! assert failed (in parse page) -
##    no table.standard_tabelle found in schedule page!!


Webget.config.sleep = 2



headers = ['league', 'count', 'seasons']
rows = []


keys = Worldfootball::LEAGUES.keys
keys.each_with_index do |key, i|

  league = Worldfootball::LEAGUES[key]
  seasons = league.seasons.map {|season| season[0]}
  pp seasons

  if key == 'nl.cup'
      ### filter 1959/60
      ##  !!! assert failed (in parse page) -
      ##    no table.standard_tabelle found in schedule page!!
     seasons = seasons.select { |season| season != '1959/60'  }
  end


  puts "==> #{i+1}/#{keys.size} #{key} - #{seasons.size} seasons(s)..."

  rows << [ key,
            seasons.size.to_s,
            seasons.reverse.join(' ')
          ]
end

pp rows


write_csv( "./max2.csv", rows, headers: headers )

puts "bye"
