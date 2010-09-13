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
		<cfset var minLength = 1/>
		<cfset var maxLength  = 0/>
		<cfset var isRangeCheck = false/>
		<cfset var parameterMessages = ""/>
		<cfset var theSize = 0/>
		<cfset var low = false/>
		<cfset var high = false/>
		<cfset var valid = true/>

		<cfif not shouldTest(arguments.validation)><cfreturn/></cfif>
		
		<cfscript>
			minLength = arguments.validation.getParameterValue("min",minLength);
			if (arguments.validation.hasParameter("max")){
				maxLength = arguments.validation.getParameterValue("max");
				isRangeCheck=true;
			}
			
			if (isSimpleValue(theVal)) {
				if (listLen(theVal) gt 1) {
					theSize = listLen(theVal);
				} else if (listLen(theVal) eq 1) {
					if (isRangeCheck) {
						theSize = len(theVal);
				 	} else {
				 		return;
					}
				}
			} else if (isStruct(theVal)) {
				theSize = structCount(theVal);
			} else if (isArray(theVal)) {
				theSize = arrayLen(theVal);
			}
			
			if (not isRangeCheck){
				valid = theSize eq minLength;
			} else {
				low = theSize lt minLength;
				high = theSize gt maxLength;
				valid = not low and not high;
			}
			
			if(not valid){
				if (isRangeCheck){
					parameterMessages = parameterMessages &  " between #minLength# and #maxLength#";
				} else {
					parameterMessages = parameterMessages &  " equal to #minLength#";
				}
			}
		</cfscript>
	
		<cfif not valid>
			<cfset fail(arguments.validation,createDefaultFailureMessage("#arguments.validation.getPropertyDesc()# size is not #parameterMessages#.")) />
		</cfif>
	</cffunction>
	
</cfcomponent>
