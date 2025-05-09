# worldfootball  - get world football (leagues, cups & more) match data via the worldfootball.net/weltfussball.de pages


* home  :: [github.com/sportdb/sport.db](https://github.com/sportdb/sport.db)
* bugs  :: [github.com/sportdb/sport.db/issues](https://github.com/sportdb/sport.db/issues)
* gem   :: [rubygems.org/gems/worldfootball](https://rubygems.org/gems/worldfootball)
* rdoc  :: [rubydoc.info/gems/worldfootball](http://rubydoc.info/gems/worldfootball)



## Usage


To get started use the `wfb` command-line tool.

List all (pre-configured) leagues:

```
$ wfb leagues
```

Print the match schedue of a league (season). Let's try the English Premier League:

```
$ wfb eng.1 2024/25
$ wfb eng.1 2024/25 --offline    # use cached (offline local) pages
```

Or try the DFB Pokal (that is, the German Cup):

```
$ wfb de.cup 2024/25 --offline    # use cached (offline local) pages
```

and so on.






### More Command-Line Tools

<!--
Debugging tips & tricks. List all cached (offline local) match schedule pages:

```
$ wfb cache
```
-->

wfbup -
wfbconv -
wfbgen -
wfbconf -   
wfbdump


#### wfbup -  download leagues (if no league passed in, download all!)

```
$ wfbup        # download ALL leagues and ALL seasons (uses all built-in configs)
$ wfbup at.1   # download ALL seasons for league 
```

#### wfbconv - convert (to .csv) leagues (if no league passed in, converts all!)

```
$ wfbconv        # convert ALL leagues and ALL seasons (uses all built-in configs)
$ wfbconv at.1   # convert ALL seasons for league 
```

#### wfbgen - generate (.txt) leagues (if no league passed in, generate all!)

```
$ wfbgen        # generate ALL leagues and ALL seasons (uses all built-in configs)
$ wfbgen at.1   # generate ALL seasons for league 
```


#### wfbconf - check built-in config(uration) for league

```
$ wfbconf eng.1
```

#### wfbdump - dump (page) slug incl. matches, teams, rounds & more

```
$ wfbdump aut-bundesliga-2024-2025
```



## License

The `worldfootball` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.


## Questions? Comments?

Yes, you can. More than welcome.
See [Help & Support »](https://github.com/openfootball/help)
