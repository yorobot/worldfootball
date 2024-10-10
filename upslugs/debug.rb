##########
#  to run use:
#   $ ruby upslugs/debug.rb

require_relative 'helper'


# check parse data & time

# 2006-03-26 02:00:00

 date_str = '2006-03-26'
 time_str = '02:00:00'
     ## note - assume central european (summer) time (cet/cest) - UTC+1 or UTC+2
     cet = CET.strptime( "#{date_str} #{time_str}", '%Y-%m-%d %H:%M' )
pp cet


puts "bye"