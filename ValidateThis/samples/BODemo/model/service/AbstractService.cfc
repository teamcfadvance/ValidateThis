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
<cfcomponent displayname="AbstractService" output="false" hint="I am the abstract service on which all other services are based.">

	<cffunction name="Init" access="Public" returntype="any" output="false" hint="I build a new Service">
		<cfset Configure() />
		<cfreturn this />
	</cffunction>

	<cffunction name="Configure" access="Public" returntype="void" output="false" hint="I am run by the Init() method">
	</cffunction>

	<cffunction name="list" access="public" output="false" returntype="query" hint="Gets a default listing from the default gateway">
		<cfargument name="objectName" type="any" required="yes" />
		<cfargument name="args" type="struct" required="yes" hint="Pass in the attributes structure.">
		<cfset var gatewayMap = getGatewayMap() />
		<cfreturn gatewayMap[arguments.objectName].list(argumentCollection=arguments.args) />
	</cffunction>

	<cffunction name="get" access="Public" returntype="any" output="false" hint="I get or create a Transfer Object.">
		<cfargument name="objectName" type="any" required="yes" />
		<cfargument name="theId" type="any" required="yes" />
		<cfargument name="readOnly" type="any" required="false" default="true" />
		<cfset var gatewayMap = getGatewayMap() />
		<cfset var theObject = gatewayMap[arguments.objectName].get(arguments.theId,arguments.readOnly) />
		<cfset var theWrapper = theObject.wrapMe() />
		<cfreturn theWrapper />
	</cffunction>

	<cffunction name="update" access="public" output="false" returntype="any" hint="Used to add or update a record.">
		<cfargument name="objectName" type="any" required="yes" />
		<cfargument name="theId" type="any" required="yes" hint="The Id of the record.">
		<cfargument name="args" type="struct" required="yes" hint="Pass in the attributes structure.">
		<cfargument name="Context" type="any" required="no" default="" />
		<cfargument name="FieldList" type="any" required="no" default="" />
		
		<cfset var theObject = get(arguments.objectName,arguments.theId,false) />
		<cfset var objResult = theObject.populate(args=arguments.args,fieldList=arguments.FieldList) />

		<cfif NOT theObject.getIsPersisted()>
			<cfset theObject.onNewProcessing(arguments.args) />
		</cfif>
		<cfset theObject.save(objResult,arguments.Context) />
		<cfreturn objResult>
				
	</cffunction>

	<cffunction name="delete" access="public" output="false" returntype="any" hint="Used to Delete a record">
		<cfargument name="objectName" type="any" required="yes" />
		<cfargument name="theId" type="any" required="yes" hint="The Id of the record.">
		
		<cfset var theObject = get(arguments.objectName,arguments.theId) />
		<cfset var objResult = theObject.delete() />
		<cfreturn objResult />
	</cffunction>

	<cffunction name="onMissingMethod" access="public" output="true" returntype="any" hint="I provide some syntactic sugar for invoking get, list, update, and delete without passing the object name as an argument.">
		<cfargument name="MissingMethodName" type="string" required="true" hint="The missing method name.">
		<cfargument name="MissingMethodArguments" type="struct" required="true" hint="The missing method arguments.">

		<!--- TODO: Had to change for Railo --->
		<cfif REFindNoCase("^(get|list|update|delete)",arguments.MissingMethodName)>
			<cfif (Left(arguments.MissingMethodName,3) is "get")>
				<cfreturn get(Right(arguments.MissingMethodName,Len(arguments.MissingMethodName)-3),arguments.MissingMethodArguments[1])>
			<cfelseif (Left(arguments.MissingMethodName,4) is "list")>
				<cfreturn list(Right(arguments.MissingMethodName,Len(arguments.MissingMethodName)-4))>
			<cfelseif (Left(arguments.MissingMethodName,6) is "update")>
				<cfset arguments.MissingMethodArguments.objectName = Right(arguments.MissingMethodName,Len(arguments.MissingMethodName)-6) />
				<cfreturn update(argumentCollection=arguments.MissingMethodArguments) />
			<cfelseif (Left(arguments.MissingMethodName,6) is "delete")>
				<cfreturn delete(Right(arguments.MissingMethodName,Len(arguments.MissingMethodName)-6),arguments.MissingMethodArguments[1])>
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="getGatewayMap" access="public" output="false" returntype="any">
		<cfreturn variables.GatewayMap />
	</cffunction>
	<cffunction name="setGatewayMap" returntype="void" access="public" output="false">
		<cfargument name="GatewayMap" type="any" required="true" />
		<cfset variables.GatewayMap = arguments.GatewayMap />
	</cffunction>

</cfcomponent>
