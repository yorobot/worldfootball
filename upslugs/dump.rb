##
#  to run use
#     $ ruby upslugs/dump.rb

require_relative 'helper'


# slug =  'caf-champions-league-2008'
# slug = 'eng-championship-1939-1940'
slug = 'ned-knvb-beker-1959-1960'


##          date         time
## [002]               |       | Académie Ny Antsika    | La Tamponnaise         | n.gesp.    | n/a
##
##  [017]    00.00.1939 |       | Barnsley FC            | Nottingham Forest      | 4:1        | n/a

Worldfootball.debug = true

##
## download fresh copy?
## Worldfootball::Metal.download_schedule( slug )


page = Worldfootball::Page::Schedule.from_cache( slug )

matches = page.matches
teams   = page.teams
rounds  = page.rounds

puts "  #{matches.size} match(es), #{teams.size} team(s), #{rounds.size} round(s)"
# pp matches

puts
puts "  #{teams.size} team(s)"
pp teams

puts
puts "  #{rounds.size} round(s)"
pp rounds

puts "bye"