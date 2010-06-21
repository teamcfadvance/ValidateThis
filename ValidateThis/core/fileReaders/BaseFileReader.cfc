<!---
	
	Copyright 2010, Bob Silverberg
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
--->
<cfcomponent output="false" hint="I am a responsible for reading and processing an XML file.">

	<cffunction name="init" returnType="any" access="public" output="false" hint="I build a new XMLFileReader">
		<cfargument name="FileSystem" type="any" required="true" />
		<cfargument name="defaultFormName" type="string" required="true" />

		<cfset variables.FileSystem = arguments.FileSystem />
		<cfset variables.defaultFormName = arguments.defaultFormName />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="processFile" returnType="any" access="public" output="false" hint="I read the validations XML file and reformat it into a struct">
		<cfargument name="fileName" type="any" required="true" />
		
		<cfthrow type="ValidateThis.core.fileReaders.BaseFileReader.MissingImplementation" detail="The processFile method must be implemented in a concrete FileReader object" />

	</cffunction>
	
	<cffunction name="determineLabel" returntype="string" output="false" access="private">
	<cfargument name="label" type="string" required="true" />
	
	<!--- Note: this is a stop-gap measure to put this functionality in place. 
		The whole metadata population system will be refactored soon. --->
	
	<cfset var i = "" />
	<cfset var char = "" />
	<cfset var result = "" />
	
	<cfloop from="1" to="#len(arguments.label)#" index="i">
		<cfset char = mid(arguments.label, i, 1) />
		
		<cfif i eq 1>
			<cfset result = result & ucase(char) />
		<cfelseif asc(lCase(char)) neq asc(char)>
			<cfset result = result & " " & ucase(char) />
		<cfelse>
			<cfset result = result & char />
		</cfif>
	</cfloop>

	<cfreturn result />	
	</cffunction>


</cfcomponent>
	

