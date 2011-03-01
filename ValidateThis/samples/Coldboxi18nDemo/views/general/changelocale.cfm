<cfprocessingdirective pageencoding="utf-8">
<cfoutput>


<h2>#getResource( "HeadingI18n" )#</h2>

<strong>Locale:</strong> #getfwLocale()#<br />
<strong>Language:</strong> #getPlugin( "i18n" ).showLanguage()#<br />
<strong>Country:</strong> #getPlugin( "i18n" ).showCountry()#<br />
<strong>TimeZone:</strong> #getPlugin( "i18n" ).getServerTZ()#<br />
<strong>i18nDateFormat:</strong> #getPlugin( "i18n" ).i18nDateFormat( getPlugin( "i18n" ).toEpoch( now() ), 1 )#<br />
<strong>i18nTimeFormat:</strong> #getPlugin( "i18n" ).i18nTimeFormat( getPlugin( "i18n" ).toEpoch( now() ), 2 )#<br />
<strong>I18NUtilVersion:</strong> #getPlugin( "i18n" ).getVersion().I18NUtilVersion#<br />
<strong>I18NUtilDate:</strong> #getPlugin( "i18n" ).dateLocaleFormat( now() )#<br />
<strong>Java version:</strong> #getPlugin( "i18n" ).getVersion().javaVersion#<br />
<hr />
<cfif getfwlocale() eq "en_GB">
<a href="#event.buildLink( linkto="general.changelocale", queryString="locale=fr_FR" )#">Passer au fran&ccedil;ais / Switch to french (fr_FR)</a>
<cfelse>
<a href="#event.buildLink( linkto="general.changelocale", queryString="locale=en_GB" )#">Switch to English / Passer &agrave; l'anglais (en_GB)</a>
</cfif>
</cfoutput>