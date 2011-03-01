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

<cfcomponent displayname="user" output="false" extends="AbstractTransferDecorator">
	
	<cffunction name="configure" access="private" returntype="void" hint="I am like init() but for decorators">
		<cfset super.configure() />
		<cfset variables.myInstance.ObjectDesc = "User" />
		<cfset setVerifyPassword("") />
	</cffunction>

	<cffunction name="populate" access="public" output="false" returntype="any" hint="Populates the TO with values from the argumemnts">
		<cfargument name="args" type="any" required="yes" />
		<cfargument name="FieldList" type="any" required="no" default="" />
		
		<cfset var Result = super.populate(argumentCollection=arguments) />
		<cfset setVerifyPassword(arguments.args.VerifyPassword) />
		<cfreturn Result />
			
	</cffunction>

	<cffunction name="CheckDupNickname" access="public" output="false" returntype="any" hint="Checks for a duplicate UserName.">

		<!--- This is just a "mock" method to test out the custom validation type --->
		<cfset var ReturnStruct = StructNew() />
		<cfset ReturnStruct.IsSuccess = false />
		<cfset ReturnStruct.FailureMessage = "That Nickname has already been used. Try to be more original!" />
		<cfif getNickname() NEQ "BobRules">
			<cfset ReturnStruct = StructNew() />
			<cfset ReturnStruct.IsSuccess = true />
		</cfif>
		<cfreturn ReturnStruct />		
	</cffunction>

	<cffunction name="setVerifyPassword" returntype="void" access="public" output="false">
		<cfargument name="VerifyPassword" type="any" required="true" />
		<cfset variables.myInstance.VerifyPassword = arguments.VerifyPassword />
	</cffunction>
	<cffunction name="getVerifyPassword" access="public" output="false" returntype="any">
		<cfreturn variables.myInstance.VerifyPassword />
	</cffunction>

</cfcomponent>

