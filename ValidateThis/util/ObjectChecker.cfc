<!---
	
	Copyright 2009, Bob Silverberg
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
--->
<cfcomponent displayname="CFMLVersion" output="false" hint="I determine the version of CFML running.">

	<cffunction name="Init" access="Public" returntype="any" output="false">

		<cfreturn this />

	</cffunction>
	
	<cffunction name="isCFC" access="public" output="false" returntype="any" hint="Returns true if the object passed in is a cfc.">
		<cfargument name="theObject" type="any" required="true" />
		
		<cfreturn isInstanceOf(arguments.theObject,"WEB-INF.cftags.component") />
	
	</cffunction>

	<cffunction name="isWheels" access="public" output="false" returntype="any" hint="Returns true if the object passed in is a cfc.">
		<cfargument name="theObject" type="any" required="true" />
		
		<cfreturn isInstanceOf(arguments.theObject,"models.Wheels") />
	
	</cffunction>

	<cffunction name="isGroovy" access="public" output="false" returntype="any" hint="Returns true if the object passed in is a cfc.">
		<cfargument name="theObject" type="any" required="true" />
		
		<cfreturn structKeyExists(arguments.theObject,"metaclass") AND isInstanceOf(arguments.theObject,"groovy.lang.MetaClassImpl") />
	
	</cffunction>

	<cffunction name="propertyExists" access="public" output="false" returntype="any" hint="Returns true if the object passed in is a cfc.">
		<cfargument name="theObject" type="any" required="true" />
		<cfargument name="propertyName" type="any" required="true" />
		
		<cfif isCFC(arguments.theObject)>
			<cfreturn structKeyExists(arguments.theObject,"get" & propertyName) />
		<cfelse>
			<cfreturn false />
		</cfif>
	
	</cffunction>

</cfcomponent>
	

