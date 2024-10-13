

teams = [
 'August 1st (Army Team)',
 'Lloyds FC (Sittingbourne)',
]


def norm( team )
  team = team.sub( /\(
                     ([^)]+?)   ## eat-up all non-greed to next )
                    \)/x, '\1' )
  team
end


teams.each do |team|
  print "#{team}  =>  "
  print norm( team )
  print "\n"
end


puts "bye"