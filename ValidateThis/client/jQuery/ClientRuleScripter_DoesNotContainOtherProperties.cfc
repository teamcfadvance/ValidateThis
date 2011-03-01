<!--- 
DoesNotContain:

Definition Usage Example:

<rule type="DoesNotContain" failuremessage="Password may not contain your first or last name." >
	<param name="propertyNames" value="firstName,LastName"/>
</rule>
<rule type="DoesNotContain" failuremessage="Password may not contain your username.">
	<param name="propertyNames" value="username" />
</rule>
<rule type="DoesNotContain" failuremessage="Password may not contain your email address." >
	<param name="propertyNames" value="emailAddress"/>
</rule>
<rule type="DoesNotContain" failuremessage="This better be ignored!" >
	<param name="propertyNames" value"="thisPropertyDoesNotExist"/>
</rule>

--->

<cfcomponent name="ClientRuleScripter_DoesNotContain" extends="AbstractClientRuleScripter" hint="Fails if the validated property contains the value of another property">
	
	<cffunction name="generateInitScript" returntype="any" access="public" output="false" hint="I generate the validation 'method' function for the client during fw initialization.">
		<cfargument name="defaultMessage" type="string" required="false" default="The value cannot not contain the value of another property.">
		<cfset var theScript="">
		<cfset var theCondition="function(value,element,options) { return true; }"/>
		<!--- JAVASCRIPT VALIDATION METHOD --->
		<cfsavecontent variable="theCondition">
		function(value,element,options) {
			var isValid = true;
			$(options).each(function(){		
				var propertyName = this;			
				var propertyValue = $(':input[name='+this+']').getValue();
				if (propertyValue.length){
					// if this is a mutilple select list, split the value into an array for iteration
					if (propertyValue.search(",")){
						propertyValue = propertyValue.split( "," )
					};
					// for each property value in the array to check
					$(propertyValue).each(function(){
						var test = value.toString().toLowerCase().search(this.toString().toLowerCase()) == -1;
						if (!test){ // Only worrie about failures here so we return true if none of the other values fail.
							isValid = false;
						}
					});
				}
				return isValid;
			});
			return isValid;
		}
		</cfsavecontent>
			
		 <cfreturn generateAddMethod(theCondition,arguments.defaultMessage)/>
	</cffunction>
	
	<cffunction name="getDefaultFailureMessage" returntype="any" access="private" output="false">
		<cfargument name="validation" type="any"/>

        <cfset var params = arguments.validation.getParameters()/>
		<cfreturn createDefaultFailureMessage("#arguments.validation.getPropertyDesc()# must not contain the values of properties named: #params.propertyNames#.") />
	</cffunction>

	<cffunction name="getParameterDef" returntype="string" access="public" output="false" hint="I generate the JS script required to pass the appropriate paramters to the validator method.">
		<cfargument name="validation" type="any"/>
		
		<cfset var params = arguments.validation.getParameters() />
		<cfreturn serializeJSON(listToArray(trim(params.propertyNames))) />
		
	</cffunction>

</cfcomponent>