REPOS = [
  'england',
  'deutschland',
  'espana',
  'italy',
  'austria',
  'europe',
  'mexico',
  'south-america',
]


## check: use setup/up as step alias too - why? why not?
step [:sync, :clone, :setup, :up] do
  #############
  ### "deep" standard/ regular clone
  REPOS.each do |repo|
    Mono.sync( "#{repo}@openfootball" )
  end


  ######
  ### shallow "fast clone" - support libraries
  ###  use https:// instead of ssh - why? why not?
  [
   'leagues@openfootball',
   'clubs@openfootball',

   'sport.db.more@yorobot',
  ].each do |repo|
    Mono.sync( repo )  # was: Mono.clone( repo, depth: 1 )
  end
end



step [:publish, :pub, :push] do
  msg = "auto-update week #{Date.today.cweek}"

  REPOS.each do |repo|
    Mono.open( "#{repo}@openfootball" ) do |proj|
      puts "check for changes in >#{Dir.pwd}<..."
      if proj.changes?
        proj.add( "." )
        proj.commit( msg )
        proj.push
      else
        puts '  - no changes -'
      end
    end
  end
end



####
# note:   use yo --require NAME to pull in (auto-require) datasets config/setup

step :write do
  write( DATASETS )
end


