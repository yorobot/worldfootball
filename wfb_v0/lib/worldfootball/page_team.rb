
module Worldfootball
  class Page

class Team < Page  ## note: use nested class for now - why? why not?

  def self.from_cache( slug )
    url  = Metal.team_url( slug )
    html = Webcache.read( url )
    new( html )
  end

  ##  rename to properties or attributes or ??
  ##             or infobox or data  or ?? why? why not?
  def props
    sidebar = doc.css( 'div.sidebar' ).first
    assert( sidebar, 'no div.sidebar found in team page!!' )

    h2  =  sidebar.css( 'h2' ).first
    assert( h2, 'no h2 inside div.sidebar found in team page!!')
    name = h2.text

    table = sidebar.css( 'table' ).first
    assert( table, 'no table inside div.sidebar found in team page!!')

    long_name = nil
    country   = nil
    ground    = nil
    founded   = nil

    trs = table.css( 'tr' )
    trs.each_with_index do |tr,i|
      text = squish(tr.text)
      ## puts "[#{i+1}] >#{text}<"

      ## assume long name first column if NOT starting w/ Land:
      if i==0 && !text.start_with?( 'Land' )
        long_name = text
      end

      if text.start_with?( 'Land:' )
         country = text.sub( 'Land:', '' ).strip
      end

      if text.start_with?( 'gegründet:' )
         founded = text.sub( 'gegründet:', '' ).strip
      end

      if text.start_with?( 'Stadion:' )
        ground = text.sub( 'Stadion:', '' ).strip
      end
    end

    data =  { name: name }
    data[ :long_name] = long_name   if long_name
    data[ :country ] = country   if country
    data[ :founded ] = founded   if founded && founded != '0000'
    data[ :ground] = ground   if ground && ground != '----------'

    data
  end

=begin
<div class="sidebar">

<div class="box emblemwrapper">
<div class="head">
<h2>Al Ahly SC</h2>
</div>
<div class="data " align="center">
<div class="emblem"><a href="/teams/al-ahly-sc/"><img src="https://s.hs-data.com/bilder/wappen/mittel/1480.gif?fallback=png" border="0" width="100" hspace="5" vspace="5" alt="Al Ahly SC" title="Al Ahly SC" /></a></div>
<div class="emblem_background"><a href="/teams/al-ahly-sc/"><img src="https://s.hs-data.com/bilder/wappen/mittel/1480.gif?fallback=png" border="0" width="100" hspace="5" vspace="5" alt="Al Ahly SC" title="Al Ahly SC" /></a></div>
</div>
<div class="data">
<table class="standard_tabelle yellow" cellpadding="3" cellspacing="0">
<tr>
<td colspan="2" align="center">Al Ahly Sporting Club</td>
</tr>
<tr>
<td colspan="2">&nbsp;</td>
</tr>
<tr>
<td align="right"><b>Land:</b></td>
<td>
<img src="https://s.hs-data.com/bilder/flaggen_neu/68.gif" width="18" height="12" hspace="5" title="Ägypten" align="absmiddle" />
Ägypten </td>
</tr>
<tr>
<td align="right"><b>gegründet:</b></td>
<td>24.04.1907</td>
</tr>
<tr>
<td align="right"><b>Stadion:</b></td>
<td><a href="/spielorte/international-stadium-cairo/" title="International Stadium">International Stadium</a></td>
</tr>
<tr>
<td align="right"><b>Homepage:</b></td>
<td><a href="http://alahlyegypt.com/" target="_blank">alahlyegypt.com/</a></td>
</tr>
<tr>
<td colspan="2" align="right"><b><a href="/teams/al-ahly-sc/1/" title="Weitere Infos zu Al Ahly SC">zum Profil &raquo;</a></b></td>
</tr>
</table>
</div>
</div>
=end


######
## helpers

end # class Team

  end # class Page
end # module Worldfootball
