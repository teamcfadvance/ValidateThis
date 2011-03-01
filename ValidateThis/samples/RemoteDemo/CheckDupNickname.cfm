<!---
	
	Copyright 2011, Bob Silverberg, John Whish
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
--->
<cfsetting enablecfoutputonly="true" />
<cfsetting showDebugOutput="false" />
<cfparam name="url.Nickname" default="" />
<cfparam name="url.callback" default="" />

<!--- note, we need to quote as Javascript is case-sensitive --->
<cfset result = "false">

<cfif url.Nickname NEQ "BobRules">
	<cfset result = "true">
</cfif>

<cfif Trim(url.callback) NEQ "">
	<!--- jQuery 1.5 or higher --->
	<cfoutput>#url.callback#(#result#)</cfoutput>
<cfelse>
	<!--- jQuery 1.4.4 or lower --->
	<cfoutput>#result#</cfoutput>
</cfif>
