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





puts Worldfootball.banner    ## say hello

