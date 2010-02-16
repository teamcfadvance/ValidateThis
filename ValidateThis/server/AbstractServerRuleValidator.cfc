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
<cfcomponent output="false" name="AbstractServerRuleValidator" hint="I am an abstract validator responsible for performing one specific type of validation.">

	<cffunction name="init" returnType="any" access="public" output="false" hint="I build a new ServerRuleValidator">

		<cfreturn this />
	</cffunction>
	
	<cffunction name="validate" returntype="void" access="public" output="false" hint="I perform the validation returning info in the validation object.">
		<cfargument name="valObject" type="any" required="yes" hint="The validation object created by the business object being validated." />

		<cfthrow type="validatethis.server.AbstractServerRuleValidator.methodnotdefined"
				message="I am an abstract object, hence the validate method must be overriden in a concrete object." />

		<!---
		<cfif false>
			<cfset fail(arguments.valObject,"Failure Message") />
		</cfif>
		--->
	</cffunction>
	
	<cffunction name="fail" returntype="void" access="private" output="false" hint="I do what needs to be done when a validation fails.">
		<cfargument name="valObject" type="any" required="yes" hint="The validation object created by the business object being validated." />
		<cfargument name="FailureMessage" type="any" required="yes" hint="An Failure message to store." />
	
		<cfset arguments.valObject.setIsSuccess(false) />
		<cfset arguments.valObject.setFailureMessage(arguments.FailureMessage) />
	</cffunction>

	
</cfcomponent>
	

