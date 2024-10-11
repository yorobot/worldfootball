$LOAD_PATH.unshift( '../../rubycocos/webclient/webget/lib' )
$LOAD_PATH.unshift( '../sport.db.more/timezones/lib' )
$LOAD_PATH.unshift( '../sport.db.more/sportdb-writers/lib' )
$LOAD_PATH.unshift( '../../sportdb/fifa/lib' )
$LOAD_PATH.unshift( './wfb/lib' )


require 'worldfootball'


Webcache.root = '/sports/cache'    ## note: use absolute path - why? why not?


## convert (default) output directory
Worldfootball.config.convert.out_dir = if File.exist?( '/sports/cache.wfb')
                                           puts "  setting convert out_dir to >/sports/cache.wfb<"
                                           '/sports/cache.wfb'
                                        else
                                           './tmp' ## use tmp in working dir
                                        end

Worldfootball.config.generate.out_dir = if File.exist?( '/sports/cache.wfb.txt')
                                           puts "  setting generate out_dir to >/sports/cache.wfb.txt<"
                                           '/sports/cache.wfb.txt'
                                        else
                                           './tmp' ## use tmp in working dir
                                        end
