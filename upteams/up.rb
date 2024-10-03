require_relative 'helper'


=begin
# slug = 'eng-premier-league-2024-2025'
# slug = 'eng-premier-league-2023-2024'
# slug = 'african-football-league-2023'
slug = 'caf-champions-league-2024-2025'


page = Worldfootball::Page::Schedule.from_cache( slug )


puts "matches:"
pp page.matches

puts
puts "teams:"
pp page.teams
=end


###
# collects teams by slug
TEAMS = {}


datasets = [
    ['at.1',     ['2024/25', '2023/24']],
    ['caf.cl',   ['2023/24','2024/25']],
    ['afl',      ['2023']],
]

## step 1 - download
datasets.each do |league_key, seasons|
    league =  Worldfootball.find_league!( league_key )  ## league info lookup
    seasons.each do |season|
        season = Season( season )
        pages = league.pages!( season: season )
        puts
        pp [league.key, season.key]
        pp pages
        puts "   #{pages.size} page(s)"

        pages.each_with_index do |(slug,_),i|
          puts "==> #{i+1}/#{pages.size} - #{league_key} @ #{slug}..."
          page = Worldfootball::Page::Schedule.from_cache( slug )
          teams = page.teams

          pp teams
          puts "   #{teams.size} teams(s)"

          teams.each do |h|
             ## pp h
             team_name = h[:name]
             team_ref  = h[:ref]
             team_url  = Worldfootball::Metal.team_url( team_ref )
             pp team_url
             if Webcache.cached?( team_url )
                ## skip download; already in cache
             else
                Worldfootball::Metal.download_team( team_ref, cache: false )
             end

             page = Worldfootball::Page::Team.from_cache( team_ref )
             props = page.props
             pp props

             TEAMS[ team_ref] = props
          end
        end
    end # each seasons
end # each league


puts "  #{TEAMS.size} team(s)"


headers = [
    'slug',
    'name',
    'country',
    'founded',
    'long_name',
    'ground'
]

pp TEAMS

rows = []
TEAMS.each do |slug, h|
    rows << [slug,
             h[:name] || '',
             h[:country] || '',
             h[:founded] || '',
             h[:long_name] || '',
             h[:ground] || '']
end

write_csv( "./tmp/teams.csv", rows, headers: headers)

puts "bye"

