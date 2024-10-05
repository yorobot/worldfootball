##################
# to run use:
#    ruby upslugs\up.rb


$LOAD_PATH.unshift( '../../../rubycocos/webclient/webget/lib' )
$LOAD_PATH.unshift( './lib' )
require 'worldfootball'


Webcache.root = '/sports/cache'    ## note: use absolute path - why? why not?


def seasons_as_yaml( seasons )
    data = {}
     seasons.each do |season, pages|
          ## flatten pages to single string
          ##  reverse - older pages first
          data[season] =  pages.reverse.map do |page|
                                 buf = String.new
                                 buf << page[0]
                                 buf << " | #{page[1]}"  if page[1]
                                 buf
                                     end
    end
    data
end


pp Worldfootball::LEAGUES

keys = %w[at.1
          be.1
          eng.1
          mx.1
        ]

keys.each do |key|
 league = Worldfootball::LEAGUES[ key ]
 data = seasons_as_yaml( league.seasons )
 puts data.to_yaml

  ## write_yml( "./seasons/ar.1.yml", data )
  write_text( "./seasons/#{key}.yml", data.to_yaml )
end

puts "bye"

__END__

league  = ARGV[0] || 'eng.1'

slug = LEAGUE_TO_SLUG[league]

if slug.nil?
    puts "!! ERROR - no slug / page configured for league >#{league}<; sorry"
    exit 1
end

puts "==> #{league} - using page/slug >#{slug}<"


Worldfootball::Metal.download_schedule( slug )


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
write_csv( "./slugs/#{league}.csv", recs, headers: headers  )


puts "bye"