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

=begin
keys = %w[at.1
          be.1
          eng.1
          mx.1
        ]
=end


keys = Worldfootball::LEAGUES.keys
keys.each do |key|
 league = Worldfootball::LEAGUES[ key ]
 data = seasons_as_yaml( league.seasons )
 puts data.to_yaml

  ## write_yml( "./seasons/ar.1.yml", data )
  write_text( "./seasons/#{key}.yml", data.to_yaml )
end


puts "bye"









