## 3rd party (our own)
require 'leagues'  ## note - pulls in season/formats, cocos & tzinfo
require 'fifa'

require 'webget'              ## incl. webget, webcache, webclient, etc.
require 'nokogiri'


require 'sportdb/writers'


###
# our own code
require_relative 'worldfootball/version'
require_relative 'worldfootball/leagues'
require_relative 'worldfootball/stages'



require_relative 'worldfootball/download'
require_relative 'worldfootball/page'
require_relative 'worldfootball/page_schedule'
require_relative 'worldfootball/page_report'
require_relative 'worldfootball/page_team'
require_relative 'worldfootball/cache'


require_relative 'worldfootball/mods'
require_relative 'worldfootball/vacuum'
require_relative 'worldfootball/build'
require_relative 'worldfootball/build-parse_score'
require_relative 'worldfootball/convert'
require_relative 'worldfootball/convert_reports'



module Worldfootball

   #########
   ## add a global debug flag
   def self.debug=(value) @debug = value; end
   def self.debug?()      @debug ||= false; end  ## note: default is FALSE

   def self.log( msg )  ### append to log
      File.open( './logs.txt', 'a:utf-8' ) do |f|
        f.write( msg )
        f.write( "\n" )
      end
   end




class Configuration
  #########
  ## nested configuration classes - use - why? why not?
  class Convert
     def out_dir()       @out_dir || './o'; end
     def out_dir=(value) @out_dir = value; end
  end
  class Generate
     def out_dir()       @out_dir || './o'; end
     def out_dir=(value) @out_dir = value; end
 end

 def convert()  @convert  ||= Convert.new; end
 def generate() @generate ||= Generate.new; end
end # class Configuration


## lets you use
##   Worldfootball.configure do |config|
##      config.convert.out_dir = './o'
##   end
def self.configure() yield( config ); end
def self.config()    @config ||= Configuration.new;  end

end   # module Worldfootball



###
# todo - move generate to generate file!!!
module Worldfootball
def self.generate( league:, season:,
                   overwrite: true )
   season = Season( season )  ## cast (ensure) season class (NOT string, integer, etc.)

   league = find_league!( league )
   pages  = league.pages!( season: season )


   out_path = if season >= Season( '2000' )
                "#{config.generate.out_dir}/#{season.to_path}/#{league.key}.txt"
              else
                decade = season.start_year - (season.start_year%10)
                ## use archive-style before 2000!!!
                "#{config.generate.out_dir}/archive/#{decade}s/#{season.to_path}/#{league.key}.txt"
              end

   ## check if output exists already
   if !overwrite && File.exist?( out_path )
     ## skip generation
     puts "  OK #{league.key} #{season}   (do NOT overwrite)"
     return
   end


   ## get matches
   path = "#{config.convert.out_dir}/#{season.to_path}/#{league.key}.csv"
   puts "  ---> reading matches in #{path} ..."
   matches = SportDb::CsvMatchParser.read( path )
   puts "     #{matches.size} matches"

   ## build
   txt = SportDb::TxtMatchWriter.build( matches )
   puts txt


   buf = String.new
   ## note - use league key for league name for now!!
   buf << "= #{league.key.upcase.gsub('.', ' ')} #{season.key}\n\n"
   buf << txt

   puts "   writing to >#{out_path}<..."
   write_text( out_path, buf )

   ## add to tmp too for debugging
   out_path2 = "#{config.generate.out_dir}/tmp/#{league.key}/#{season.to_path}.txt"
   puts "   writing to >#{out_path2}<..."
   write_text( out_path2, buf )
end
end   # module Worldfootball




puts Worldfootball.banner    ## say hello

