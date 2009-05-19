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
<cfcomponent displayname="onMMHelper" output="false" hint="I do a cfinvoke using some hacks required to support Railo.">

	<cffunction name="Init" access="Public" returntype="any" output="false">

		<cfset variables.CFMLVersion = createObject("component","ValidateThis.util.CFMLVersion").init() />
		<cfreturn this />

	</cffunction>
	
	<cffunction name="doInvoke" access="public" output="false" returntype="any" hint="Performs a cfinvoke using the Railo hack.">
		
		<cfargument name="methodName" type="any" required="true" />
		<cfargument name="methodArguments" type="any" required="true" />
		<cfargument name="objectToInvoke" type="any" required="true" />

		<cfset var local = {} />
		<cfset local.returnValue = "" />
		
	    <!--- have to do this bizarre lookup, as railo seems to think '1' is in the struct keys for mmA --->
	    <cfset local.keyArray = StructKeyArray(arguments.methodArguments) />
	    <cfif NOT StructIsEmpty(arguments.methodArguments)
	            AND local.keyArray[1] eq 1
	            AND	StructKeyExists(arguments.objectToInvoke,arguments.methodName)> --->
	        <cfset local.meta = getMetadata(arguments.objectToInvoke[arguments.methodName]) />
			<cfset local.i = 1 />
			<cfinvoke component="#arguments.objectToInvoke#" method="#arguments.methodName#" returnvariable="local.returnValue">
	            <cfloop array="#arguments.methodArguments#" index="local.arg">
	                <cfinvokeargument name="#local.meta.parameters[local.i++].name#" value="#local.arg#">
	            </cfloop>
	        </cfinvoke>
	    <cfelse>
		    <cftry>
				<cfinvoke component="#arguments.objectToInvoke#" method="#arguments.methodName#" argumentcollection="#arguments.methodArguments#" returnvariable="local.returnValue" />
				<cfcatch type="any">
					<cfdump var="#cfcatch#" label="onMMHelper Error" />
				</cfcatch>
			</cftry>
	    </cfif>
		<cfif NOT StructKeyExists(local,"returnValue")>
			<cfset local.returnValue = "" />
		</cfif>
		<cfreturn local.returnValue />
		
	</cffunction>

</cfcomponent>
	

