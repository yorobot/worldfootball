##########
#  to run use:
#   $ ruby upslugs/rounds.rb




require_relative 'helper'


Webget.config.sleep = 2




###
# calculate rounds usage
ROUNDS = {}



def analyse( slug, id: )
  ## note: check if passed in slug is cached too (if not - preload / download too)
  url = Worldfootball::Metal.schedule_url( slug )

  if Webcache.cached?( url )
    print "   OK "
    cached = true
  else
    puts "!! ERROR - page/slug not in cache >#{slug}<"
    exit 1
  end


     page = Worldfootball::Page::Schedule.from_cache( slug )

     ## clean-up title/strip "» Spielplan" from title
     print '  /  '
     print page.title.sub('» Spielplan', '').strip
     print "\n"

     rounds  = page.rounds
## e.g.
## [{:count=>8, :name=>"Viertelfinale"},
##  {:count=>4, :name=>"Halbfinale"},
##  {:count=>2, :name=>"Finale"}]

     rounds.each do |rec|
          round = rec[:name]
          count = rec[:count]

         stat = ROUNDS[ round ] ||= { count: 0,
                                      leagues: [] }
         stat[:count] += count
         stat[:leagues] << id
     end
end # method preload



keys = Worldfootball::LEAGUES.keys    ## [0,3]


keys.each_with_index do |key, i|

  league = Worldfootball::LEAGUES[key]

  seasons = league.seasons

  puts "==> #{i+1}/#{keys.size} #{key} - #{seasons.size} seasons(s)..."

  seasons.each_with_index do |season_rec,j|
    season = season_rec[0]

    next if key == 'nl.cup' && season == '1959/60'

    pages = league.pages( season: season )
    puts "  #{j+1}/#{seasons.size} #{key} #{season} - #{pages.size} page(s)..."
    pages.each do |slug,_|
      ## pass along id - league key + season
      id = "#{key}+#{season}"
      analyse( slug, id: id )
    end
  end
end



buf = ROUNDS.pretty_inspect
puts buf

write_text( "./tmp/rounds.txt", buf )

puts "bye"
