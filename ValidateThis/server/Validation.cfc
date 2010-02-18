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
<cfcomponent displayname="Validation" output="false" hint="I am a transient validation object.">

	<cffunction name="init" access="Public" returntype="any" output="false" hint="I am the pseudo-constructor">

		<cfargument name="theObject" type="any" required="yes" hint="The object being validated" />
		<cfargument name="ObjectChecker" type="any" required="yes" hint="A component used to distinguish object types" />
		<cfargument name="propertyMode" type="any" required="false" default="getter" hint="The method of determining property values" />
		<cfset variables.theObject = arguments.theObject />
		<cfset variables.ObjectChecker = arguments.ObjectChecker />
		<cfset variables.propertyMode = arguments.propertyMode />
		<cfreturn this />

	</cffunction>

	<cffunction name="load" access="Public" returntype="any" output="false" hint="I load a fresh validation rule into the validation object, which allows it to be reused">

		<cfargument name="ValStruct" type="any" required="yes" hint="The validation struct from the xml file" />

		<cfset variables.instance = Duplicate(arguments.ValStruct) />
		<cfset variables.instance.IsSuccess = true />
		<cfset variables.instance.FailureMessage = "" />
		<cfreturn this />

	</cffunction>

	<cffunction name="getObjectValue" access="public" output="false" returntype="any" hint="I return the value from the stored object that corresponds to the field being validated.">
		<cfset var theValue = "" />
		<cfset var propertyName = getPropertyName() />
		<cfset var methodExists = false />
		
		<cfif variables.propertyMode EQ "getter">
			<!--- Note: isInstanceOf() is being used to identify Groovy or Java objects, 
				the existence of whose methods can not be checked via structKeyExists().
				The problem with this approach is that if a method does not exist in a Java/Groovy object, 
				no error will be thrown. The getObjectValue() method will simply return an empty string.
				This should be addressed in a future version --->
			<cfif variables.ObjectChecker.isCFC(theObject)>
				<cfset methodExists = StructKeyExists(theObject,"get" & propertyName)>			
			<cfelse>
				<cfset methodExists = true />
			</cfif>
			<cfif methodExists>
				<!--- Using try/catch to deal with composed objects that throw an error if they aren't loaded --->
				<cftry>
					<cfset theValue = evaluate("variables.theObject.get#capFirst(propertyName)#()") />
					<cfcatch type="any"></cfcatch>
				</cftry>
				<cfif NOT IsDefined("theValue")>
					<cfset theValue = "" />
				</cfif>
				<cfreturn theValue />
			<cfelse>
				<cfthrow type="validatethis.server.validation.propertyNotFound"
						message="The property #propertyName# was not found in the object passed into the validation object." />
			</cfif>
		<cfelseif variables.propertyMode EQ "wheels">		
			<cfif StructKeyExists(variables.theObject.properties(),propertyName)>
				<cfreturn variables.theObject.$propertyvalue(propertyName) />
			<cfelse>
				<cfthrow type="validatethis.server.validation.propertyNotFound"
						message="The property #propertyName# was not found in the object passed into the validation object." />
			</cfif>
		<cfelse>
			<cfthrow type="ValidateThis.server.validation.InvalidPropertyMode" message="The propertyMode (#variables.propertyMode#) is not valid.">
		</cfif>
	</cffunction>

	<cffunction name="getMemento" access="public" output="false" returntype="any">
		<cfreturn variables.instance />
	</cffunction>

	<cffunction name="getValType" access="public" output="false" returntype="any">
		<cfreturn variables.instance.ValType />
	</cffunction>
	<cffunction name="setValType" access="public" output="false" returntype="void">
		<cfargument name="ValType" type="any" required="yes" />
		<cfset variables.instance.ValType = arguments.ValType />
	</cffunction>

	<cffunction name="getPropertyName" access="public" output="false" returntype="any">
		<cfreturn variables.instance.PropertyName />
	</cffunction>
	<cffunction name="setPropertyName" access="public" output="false" returntype="void">
		<cfargument name="PropertyName" type="any" required="yes" />
		<cfset variables.instance.PropertyName = arguments.PropertyName />
	</cffunction>

	<cffunction name="getPropertyDesc" access="public" output="false" returntype="any">
		<cfreturn variables.instance.PropertyDesc />
	</cffunction>
	<cffunction name="setPropertyDesc" access="public" output="false" returntype="void">
		<cfargument name="PropertyDesc" type="any" required="yes" />
		<cfset variables.instance.PropertyDesc = arguments.PropertyDesc />
	</cffunction>

	<!--- TODO: Look at how this will work now --->
	<cffunction name="getFormName" access="public" output="false" returntype="any">
		<cfreturn variables.instance.FormName />
	</cffunction>
	<cffunction name="setFormName" access="public" output="false" returntype="void">
		<cfargument name="FormName" type="any" required="yes" />
		<cfset variables.instance.FormName = arguments.FormName />
	</cffunction>

	<cffunction name="setParameters" returntype="void" access="private" output="false">
		<cfargument name="Parameters" type="any" required="true" />
		<cfset variables.instance.Parameters = arguments.Parameters />
	</cffunction>
	<cffunction name="getParameters" access="public" output="false" returntype="any">
		<cfreturn variables.instance.Parameters />
	</cffunction>

	<cffunction name="setCondition" returntype="void" access="private" output="false">
		<cfargument name="Condition" type="any" required="true" />
		<cfset variables.instance.Condition = arguments.Condition />
	</cffunction>
	<cffunction name="getCondition" access="public" output="false" returntype="any">
		<cfreturn variables.instance.Condition />
	</cffunction>

	<cffunction name="setTheObject" returntype="void" access="public" output="false">
		<cfargument name="theObject" type="any" required="true" />
		<cfset variables.theObject = arguments.theObject />
	</cffunction>
	<cffunction name="getTheObject" access="public" output="false" returntype="any">
		<cfreturn variables.theObject />
	</cffunction>

	<cffunction name="setIsSuccess" returntype="void" access="public" output="false">
		<cfargument name="IsSuccess" type="any" required="true" />
		<cfset variables.Instance.IsSuccess = arguments.IsSuccess />
	</cffunction>
	<cffunction name="getIsSuccess" access="public" output="false" returntype="any">
		<cfreturn variables.Instance.IsSuccess />
	</cffunction>

	<cffunction name="setFailureMessage" returntype="void" access="public" output="false">
		<cfargument name="FailureMessage" type="any" required="true" />
		<cfset variables.Instance.FailureMessage = arguments.FailureMessage />
	</cffunction>
	<cffunction name="getFailureMessage" access="public" output="false" returntype="any">
		<cfreturn variables.Instance.FailureMessage />
	</cffunction>

	<cffunction name="setPropertyMode" returntype="void" access="public" output="false">
		<cfargument name="propertyMode" type="any" required="true" />
		<cfset variables.propertyMode = arguments.propertyMode />
	</cffunction>
	<cffunction name="getPropertyMode" access="public" output="false" returntype="any">
		<cfreturn variables.propertyMode />
	</cffunction>

	<!---
	
	This is used to address case sensitivity issues with Java/Groovy method names.
	Should be in a separate, injected object as it is used elsewhere.
	
	Capitalizes the first letter in each word.
	Made udf use strlen, rkc 3/12/02
	v2 by Sean Corfield.
	
	@param string      String to be modified. (Required)
	@return Returns a string.
	@author Raymond Camden (ray@camdenfamily.com)
	@version 2, March 9, 2007
	--->
	<cffunction name="CapFirst" returntype="string" output="false">
	    <cfargument name="str" type="string" required="true" />
	    
	    <cfset var newstr = "" />
	    <cfset var word = "" />
	    <cfset var separator = "" />
	    
	    <cfloop index="word" list="#arguments.str#" delimiters=" ">
	        <cfset newstr = newstr & separator & UCase(left(word,1)) />
	        <cfif len(word) gt 1>
	            <cfset newstr = newstr & right(word,len(word)-1) />
	        </cfif>
	        <cfset separator = " " />
	    </cfloop>
	
	    <cfreturn newstr />
	</cffunction>

</cfcomponent>
	

