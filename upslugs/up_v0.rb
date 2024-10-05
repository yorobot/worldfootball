##################
# to run use:
#    ruby upslugs\up_v0.rb


$LOAD_PATH.unshift( '../../../rubycocos/webclient/webget/lib' )
$LOAD_PATH.unshift( './lib' )
require 'worldfootball'


Webcache.root = '/sports/cache'    ## note: use absolute path - why? why not?


pp Worldfootball::LEAGUES

keys = Worldfootball::LEAGUES.keys
keys.each do |key|
  league = Worldfootball::LEAGUES[ key ]
  slug = league.slug

  puts "==> #{key} - using page/slug >#{slug}<"
  page = Worldfootball::Page::Schedule.from_cache( slug )

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

  ## note - only update local csv dataset on download
  headers = ['season','slug']
  write_csv( "./slugs/#{key}.csv", recs, headers: headers  )
end


puts "bye"

