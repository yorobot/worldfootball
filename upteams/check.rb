$LOAD_PATH.unshift( '../../sportdb/fifa/lib' )
require 'fifa'
require 'cocos'

recs = read_csv( './tmp/teams.csv')
puts "  #{recs.size} record(s)"


missing = Hash.new(0)

recs.each do |rec|
    country_name = rec['country']

    cty = Fifa.world.find_by_name( country_name )
    if cty.nil?
        missing[ country_name ] += 1
    end
end

pp missing
puts "   #{missing.size} missing countries"

puts "bye"

