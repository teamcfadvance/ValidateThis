<cfoutput>
<h1>ValidateThis CF9 ORM ColdBox Demo</h1>
<h3>#rc.PageHeading#</h3>

#getPlugin( "MessageBox" ).renderit()#

<ul>
	<cfloop array="#rc.Users#" index="user">
	<li>
		#User.getNickname()# <a href="#event.buildLink( linkto="general.maintain", queryString="userid=#User.getUserID()#" )#">edit</a>
	</li>
	</cfloop>
</ul>


</cfoutput>