require 'sportdb/catalogs'

## use (switch to) "external" datasets
SportDb::Import.config.leagues_dir = Mononame.real_path( 'leagues@openfootball' )
SportDb::Import.config.clubs_dir   = Mononame.real_path( 'clubs@openfootball')


## note: use (latest) source version for writers for now - why? why not?
$LOAD_PATH.unshift( Monopath.real_path( 'sportdb-writers/lib@yorobot/sport.db.more' ))
require 'sportdb/writers'






require_relative 'config'



def write( datasets )
    source_path = File.expand_path( './two' )
    puts "[debug] source_path: #{source_path}"

    ## todo/check/fix:  (double) check config.out_dir - always (auto) expand path?
    if debug?
      Writer.config.out_dir = File.expand_path( './tmp' )
    else
      ## todo/check/fix:  allow Mononame with org/owner only e.g. @openfootball!!! - why? why not?
      Writer.config.out_dir = "#{Mono.root}/openfootball"
    end

    puts "[debug] writer.config.out_dir: #{Writer.config.out_dir}"
    Writer::Job.write( datasets,
                       source: source_path )
end