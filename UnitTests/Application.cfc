<!---
	
filename:		\VTDemo\UnitTests\Application.cfc
date created:	2008-10-22
author:			Bob Silverberg (http://www.silverwareconsulting.com/)
purpose:		I Application.cfc
				
	// **************************************** LICENSE INFO **************************************** \\
	
	Copyright 2008, Bob Silverberg
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
	// ****************************************** REVISIONS ****************************************** \\
	
	DATE		DESCRIPTION OF CHANGES MADE												CHANGES MADE BY
	===================================================================================================
	2008-10-22	New																		BS

--->
<cfcomponent output="false">

	<!--- Set up application variables --->
	<!--- set application name based on the directory path --->
	<cfsetting requesttimeout="200" />
	<cfset this.name = right(REReplace(ReplaceNoCase(getDirectoryFromPath(getCurrentTemplatePath()),'\jobs',''),'[^A-Za-z]','','all'),64) />
	<cfset this.applicationtimeout = "#CreateTimeSpan(10,0,0,0)#" />
	<cfset this.sessiontimeout = "#CreateTimeSpan(0,0,0,2)#" />
	<cfset this.clientmanagement = false />
	<cfset this.sessionmanagement = true />
	<cfset this.setclientcookies = false />
	<cfset this.mappings = createMappings() />

	<cffunction name="createMappings" access="private" output="false" returntype="struct">
		<cfargument name="pathPrefix" type="string" required="false" default="../../">
		<cfset var mappings = StructNew()>
		<cfset var i = "">
		<!--- TODO: Make this dynamic based on server --->
		<cfloop index="i" list="model,TransferTemp" delimiters=",">
			<cfset mappings["/" & ListLast(i,"_")] = expandPath(arguments.pathPrefix) & i />
		</cfloop>
		<cfreturn mappings>
	</cffunction>

</cfcomponent>
