# Notes



## TODOs

```
CAF Africa

- [ ]  fix "generic" group   - do NOT map; use Gruppe A/B/C/D/etc.

MLS

- [ ] add  "special" (missing) league to mls 2020
       - https://www.weltfussball.de/wettbewerb/usa-mls-is-back-ko-stage/
      NOT automagically part of 2020 season
```


---

- [ ] add/update config for int'l cups tournaments flag !!!

- [ ]  convert concaf - add to intl!!! to auto-add country codes
    - concacaf.cl
    - uefa.cl
    - uefa.cl.q
    - uefa.el
    - uefa.el.q
    - uefa.conf
    - uefa.conf.q
- [ ] add a new row column to all csv exports - why? why not?


```
fix - generate match without date!!! e.g.
sportdb-writers-0.3.0/lib/sportdb/writers/txt_writer.rb:180:in `block in _build_batch': undefined method `strftime' for nil:NilClass (NoMethodError)

     date_yyyymmdd = date.strftime( '%Y-%m-%d' )
                         ^^^^^^^^^
```


```
[cache] saving /sports/cache/www.weltfussball.de/teams/sporting-praia-cruz.html...
{:name=>"Sporting Praia Cruz", :country=>"São Tomé und Príncipe"}
!! ERROR - no country found for São Tomé und Príncipe
```

- [ ]  move admin scripts from upslugs to admin/ - why? why not?



## more todos
- [ ] automate slugs / seasons (stages) config
  - [ ] try to auto-get all slugs from all configured leagues (50+)
  - [ ]    use slugs to double check config
           and exit/warn on conflict !!!!!

- [ ]  check fix date - change to use timezone!!!!

---

## more data (score) errors

```
in be.cup 2024/25
[013] 6. Runde => Round 6
[013]    2024-09-08 | 16:00 | RJ Rochefortoise FC    | KFC VW Hamme           | 0-0 i.E.
!! ERROR - unsupported score format >0-0 i.E.< - sorry; maybe add a score error fix/patch
```


## How-to update (cached) datasets

Find the (cached) datasets by season in the comma-separated values (.csv) format @ <https://github.com/footballcsv/cache.wfb>



Sample 1 - Austria (at) 2024/25

- Austrian ÖFB Cup  (at.cup)  =>  `$ wfb at.cup 2024/25`



## data fixes

```
eng.2  >eng-championship-1939-1940<

[016] round >4. Spieltag<
[017]    00.00.1939 |       | Barnsley FC            | Nottingham Forest      | 4:1        | n/a

page_schedule.rb:218:in `strptime': invalid date (Date::Error)
```




## more

```
 add more helpers
  move upstream for (re)use - why? why not?

 todo/check: what to do: if league is both included and excluded?
   include forces include? or exclude has the last word? - why? why not?
  Excludes match before includes,
   meaning that something that has been excluded cannot be included again
```



## Older Todos

```
!! ERROR - no club match found for >Astra Ploieşti<
!! ERROR - no club match found for >CSM Studențesc Iași<
!! ERROR - no club match found for >FC Victoria Brăneşti<
!! ERROR - no club match found for >Voinţa Sibiu<


ro.1 2013/14

[016] 2. Spieltag => 2
[016]    2013-07-29 | 18:00 | FC Brașov              | Săgeata Năvodari       | 1-1 (0-0, 0-1)

29.07.2013	18:00	FC Brașov	-	Săgeata Năvodari	1:1 (0:0, 0:1)
!! ERROR - unsupported score format >1-1 (0-0, 0-1)< - sorry

fix to:
1:1 (0:0)
0 : 1	Sorin Chiţu 75.
1 : 1	Cristian Ionescu 90.
```