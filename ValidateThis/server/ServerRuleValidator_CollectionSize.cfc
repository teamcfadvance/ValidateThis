<!---
	Copyright 2010, Bob Silverberg, Adam Drew
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	

	Size
	@adam drew, 2010
	
	notes: 
	use Size to check the min and/or max of the length for a multi list selection or some other javascript collection on the client, and the length of arrays, lists, and struct counts on the server.
	for String length input size use the Range validator.
	
	example usage:

	Company.xml
	<property name="Accounts">
		<rule type="size" context="Personal" failuremessage="This company must have at least 1 or more acccounts.">
			<param name="min" value="1"/>
		</rule>
		<rule type="size" context="Business" failuremessage="This company can have anywhere from 2 to 100 acccounts.">
			<param name="min" value="2"/>
			<param name="max" value="100"/>
		</rule>	
	</property>
	
	<property name="Employees">
		<rule type="size" context="Small" failuremessage="This small business must have between 1 to 45 employees to qualify.">
			<param name="min" value="1"/>
			<param name="max" value="45"/>
		</rule>
		<rule type="size" context="Medium" failuremessage="This medium business must have between 46 and 150 employees to qualify.">
			<param name="min" value="46"/>
			<param name="max" value="150"/>
		</rule>
		<rule type="size" context="Large" failuremessage="This large business must have more then 150 employees to qualify.">
			<param name="min" value="150"/>
		</rule>	
	</property>

	
--->
<cfcomponent output="false" name="ServerRuleValidator_Size" extends="AbstractServerRuleValidator" hint="I am responsible for performing the Size validation.">

	<cffunction name="validate" returntype="any" access="public" output="false" hint="I perform the validation returning info in the validation object.">
		<cfargument name="validation" type="any" required="yes" hint="The validation object created by the business object being validated." />
		<cfargument name="locale" type="string" required="yes" hint="The locale to use to generate the default failure message." />
		<cfset var theVal = arguments.validation.getObjectValue()/>
		<cfset var minLength = 0/>
		<cfset var maxLength  = 0/>
		<cfset var isRangeCheck = false/>
		<cfset var parameterMessages = ""/>
		<cfset var theSize = 0/>
		<cfset var low = false/>
		<cfset var high = false/>
		<cfset var valid = true/>
		<cfset var args = [arguments.validation.getPropertyDesc()] />
		<cfset var msgKey = "" />

		<cfif not shouldTest(arguments.validation)><cfreturn/></cfif>
		
		<cfscript>
			minLength = arguments.validation.getParameterValue("min",minLength);
			
			if (arguments.validation.hasParameter("max")){
				maxLength = arguments.validation.getParameterValue("max");
				isRangeCheck = true;
			} else {
				maxLength = minLength;
			}
			
			if (isSimpleValue(theVal)) {
				theSize = listLen(theVal);
			} else if (isStruct(theVal)) {
				theSize = structCount(theVal);
			} else if (isArray(theVal)) {
				theSize = arrayLen(theVal);
			}
			
			valid = theSize lt minLength or theSize gt maxLength;
			
			if(not valid){
				arrayAppend(args,minLength);
				if (isRangeCheck){
					msgKey = "defaultMessage_CollectionSize_Between";
					arrayAppend(args,maxLength);
				} else {
					msgKey = "defaultMessage_CollectionSize_GTE";
				}
			}
		</cfscript>
		
		<cfif not valid>
			<cfset fail(arguments.validation,variables.messageHelper.getGeneratedFailureMessage(msgKey,args,arguments.locale)) />
		</cfif>
		
	</cffunction>
</cfcomponent>
