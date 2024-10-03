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

__END__

{"Sansibar"=>2,
 "Äthiopien"=>2,
 "Algerien"=>3,
 "Tunesien"=>3,
 "Komoren"=>2,
 "Südafrika"=>2,
 "Ruanda"=>1,
 "Sambia"=>2,
 "Gabun"=>1,
 "Kamerun"=>2,
 "Mosambik"=>2,
 "DR Kongo"=>3,
 "Tansania"=>3,
 "Kongo"=>2,
 "Äquatorialguinea"=>2,
 "Marokko"=>3,
 "Elfenbeinküste"=>3,
 "Mauretanien"=>1,
 "Libyen"=>3,
 "Südsudan"=>2,
 "Ägypten"=>2,
 "Simbabwe"=>1,
 "Seychellen"=>1,
 "Zentralafr. Republik"=>1,
 "Madagaskar"=>1,
 "Kenia"=>1,
 "Tschad"=>1}
   27 missing countries