<!---
	
	Copyright 2010, Adam Drew
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
--->
<cfcomponent output="false" name="ServerRuleValidator_Size" extends="AbstractServerRuleValidator" hint="I am responsible for performing the Size validation.">

	<cffunction name="validate" returntype="any" access="public" output="false" hint="I perform the validation returning info in the validation object.">
		<cfargument name="validation" type="any" required="yes" hint="The validation object created by the business object being validated." />
		<cfset var theVal = arguments.validation.getObjectValue()/>
		<cfset var exactLength = 0/>
		<cfset var minLength = 0/>
		<cfset var maxLength  = 0/>
		<cfset var valid = true/>
		<cfset var parameterMessages = ""/>
		<cfset var exactMessage = ""/>
		<cfset var minMessage = ""/>
		<cfset var maxMessage= ""/>
		
		<cfif arguments.validation.hasParameter("length")>
			<cfset exactLength = arguments.validation.getParameterValue("length",exactLength)/>
			<cfset exactMessage=  " exactly #exactLength#">
			<cfif isSimpleValue(theVal)>
				<cfif listLen(theVal) gt 1 and listLen(theVal) neq exactLength>
					<cfset valid = false>
				<cfelseif listLen(theVal) eq 1 and len(theVal) neq exactLength>
					<cfset valid = false>
				</cfif>			
			<cfelseif isStruct(theVal) and structCount(theVal) neq exactLength>
				<cfset valid = false>
			<cfelseif isArray(theVal) and arrayLen(theVal) neq exactLength>
				<cfset valid = false>
			</cfif>
			<cfif !valid>
				<cfset parameterMessages = parameterMessages & "#exactMessage#"/>
			</cfif>
		<cfelse>
			
			<cfif arguments.validation.hasParameter("min")>
				<cfset minLength = arguments.validation.getParameterValue("min",minLength)/>
				<cfset minMessage =  "at least #minLength#">
				<cfif isSimpleValue(theVal)>
					<cfif listLen(theVal) gt 1 and listLen(theVal) lt minLength>
						<cfset valid = false>
					<cfelseif listLen(theVal) eq 1 and len(theVal) lt minLength>
						<cfset valid = false>
					</cfif>			
				<cfelseif isStruct(theVal) and structCount(theVal) lt minLength>
					<cfset valid = false>
				<cfelseif isArray(theVal) and arrayLen(theVal) lt minLength>
					<cfset valid = false>
				</cfif>
				<cfif !valid>
					<cfset parameterMessages = parameterMessages & "#minMessage#"/>
				</cfif>
			</cfif>
						
			<cfif valid and arguments.validation.hasParameter("max")>
				<cfset maxLength = arguments.validation.getParameterValue("max",maxLength)/>
				<cfset maxMessage =  " at most #maxLength#">
				<cfif isSimpleValue(theVal)>
					<cfif listLen(theVal) gt 1 and listLen(theVal) gt maxLength>
						<cfset valid = false>
					<cfelseif listLen(theVal) eq 1 and len(theVal) gt maxLength>
						<cfset valid = false>
					</cfif>			
				<cfelseif isStruct(theVal) and structCount(theVal) gt maxLength>
					<cfset valid = false>
				<cfelseif isArray(theVal) and arrayLen(theVal) gt maxLength>
					<cfset valid = false>
				</cfif>
				<cfif !valid>
					<cfset parameterMessages = parameterMessages & "#maxMessage#"/>
				</cfif>
			</cfif>		
		</cfif>

		<cfif shouldTest(arguments.validation) AND not valid>
			<cfset fail(arguments.validation,createDefaultFailureMessage("#arguments.validation.getPropertyDesc()# does not match the size requirement of #parameterMessages#.")) />
		</cfif>
	</cffunction>
	
</cfcomponent>
