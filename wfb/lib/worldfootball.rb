## 3rd party (our own)
require 'football/timezones'  ## note - pulls in season/formats, cocos & tzinfo
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
def self.generate( league:, season: )
   season = Season( season )  ## cast (ensure) season class (NOT string, integer, etc.)
   league_key = league

   path = "#{config.convert.out_dir}/#{season.to_path}/#{league_key}.csv"
   ## get matches
   puts "  ---> reading matches in #{path} ..."
   matches = SportDb::CsvMatchParser.read( path )
   puts "     #{matches.size} matches"

   ## build
   txt = SportDb::TxtMatchWriter.build( matches )
   puts txt

   path =  if season >= Season( '2000' )
             "#{config.generate.out_dir}/#{season.to_path}/#{league_key}.txt"
           else
             decade = season.start_year - (season.start_year%10)
             ## use archive-style before 2000!!!
             "#{config.generate.out_dir}/archive/#{decade}s/#{season.to_path}/#{league_key}.txt"
           end

   buf = String.new
   ## note - use league key for league name for now!!
   buf << "= #{league_key.upcase.gsub('.', ' ')} #{season.key}\n\n"
   buf << txt

   puts "   writing to >#{path}<..."
   write_text( path, buf )
end
end   # module Worldfootball




puts Worldfootball.banner    ## say hello

