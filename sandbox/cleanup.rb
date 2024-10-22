require 'cocos'

# files = Dir.glob( "/sports/cache.wfb.txt/**/{cz.3,mx.3}.txt" )
files = Dir.glob( "/sports/cache.wfb.txt/**/mx.2.txt" )

pp files
puts "  #{files.size} file(s)"

files.each do |file|
  FileUtils.rm( file )
end

puts "bye"