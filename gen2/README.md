# Update Notes


- get datasets via wfbsync
  - will (automagically) re(use) cached pages for season NOT latest

```
$ ruby -I wfb/lib wfb/bin/wfbsync -f world.csv 
```




## Notes & Todos

### CAF Africa

- [ ]   fix "generic" group   - do NOT map; use Gruppe A/B/C/D/etc.


### MLS

- [ ] add  "special" (missing) league to mls 2020
       - https://www.weltfussball.de/wettbewerb/usa-mls-is-back-ko-stage/
      NOT automagically part of 2020 season