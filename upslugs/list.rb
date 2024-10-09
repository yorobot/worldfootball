##########
#  to run use:
#   $ ruby upslugs/list.rb


require_relative 'helper'


start_time = Time.now   ## todo: use Timer? t = Timer.start / stop / diff etc. - why? why not?


# pages = Dir.glob( './dl/at*' )
pages = Dir.glob( "#{Webcache.root}/www.weltfussball.de/alle_spiele/*.html" )
puts "#{pages.size} pages"   #=> 3672 pages
puts


pages.each do |path|
   basename = File.basename( path, File.extname( path ) )
   print "%-50s" % basename
   print "\n"
end


puts "#{pages.size} pages"   #=> 3672 pages
puts


end_time = Time.now
diff_time = end_time - start_time
puts "convert_all: done in #{diff_time} sec(s)"

puts "bye"
