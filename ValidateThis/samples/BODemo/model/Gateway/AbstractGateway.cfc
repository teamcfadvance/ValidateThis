<!---
	
	Copyright 2008, Bob Silverberg
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
--->
<cfcomponent displayname="AbstractGateway" output="false">

	<cffunction name="Init" access="Public" returntype="any" output="false" hint="I build a new Gateway">
		<cfset configure() />
		<cfreturn this />
	</cffunction>

	<cffunction name="configure" access="Public" returntype="void" output="false" hint="I am run by the Init() method">
	</cffunction>

	<cffunction name="get" access="Public" returntype="any" output="false" hint="I get or create a Transfer Object.">
		<cfargument name="theId" type="any" required="yes" />
		<cfargument name="readOnly" type="any" required="false" default="true" />
		<cfset var theObject = 0 />
		<cfif (IsNumeric(arguments.theId) AND NOT Val(arguments.theId)) OR NOT Len(arguments.theId)>
			<cfset theObject = getTransfer().new(getTransferClassName()) />
		<cfelse>
			<cfset theObject = getTransfer().get(getTransferClassName(),arguments.theId) />
			<cfif NOT arguments.readOnly>
				<cfset theObject = theObject.clone() />
			</cfif>
		</cfif>
		<cfreturn theObject />
	</cffunction>
	
	<cffunction name="save" access="public" output="false" returntype="void" hint="Calls Transfer.save().">
		<cfargument name="theObject" type="any" required="true" />
		<cfset getTransfer().save(arguments.theObject) />
	</cffunction>

	<cffunction name="delete" access="public" output="false" returntype="void" hint="Calls Transfer.delete().">
		<cfargument name="theObject" type="any" required="true" />
		<cfset getTransfer().delete(arguments.theObject) />
	</cffunction>

	<cffunction name="list" access="public" output="false" returntype="query" hint="Returns a query containing all records in the table, ordered by the DescColumn">
	
		<cfreturn getTransfer().list(getTransferClassName(),getDescColumn()) />

	</cffunction>

	<cffunction name="getTransfer" access="public" output="false" returntype="any">
		<cfreturn variables.Transfer />
	</cffunction>
	<cffunction name="setTransfer" returntype="void" access="public" output="false">
		<cfargument name="transfer" type="any" required="true" />
		<cfset variables.Transfer = arguments.Transfer />
	</cffunction>

	<cffunction name="getTransferClassName" access="public" output="false" returntype="any">
		<cfreturn variables.TransferClassName />
	</cffunction>
	<cffunction name="setTransferClassName" returntype="void" access="public" output="false">
		<cfargument name="TransferClassName" type="any" required="true" />
		<cfset variables.TransferClassName = arguments.TransferClassName />
	</cffunction>

	<cffunction name="getDescColumn" access="public" output="false" returntype="any">
		<cfreturn variables.DescColumn />
	</cffunction>
	<cffunction name="setDescColumn" returntype="void" access="public" output="false">
		<cfargument name="DescColumn" type="any" required="true" />
		<cfset variables.DescColumn = arguments.DescColumn />
	</cffunction>

</cfcomponent>

