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
<cfparam name="SuccessMessage" default="" />

<cfif Form.Context EQ "Profile">
	<cfset PageHeading = "Editing an existing User" />
	<cfset Form.UserId = 1 />
<cfelse>
	<cfset PageHeading = "Registering a new User" />
</cfif>

<!--- We need a User record --->
<cfset user = createObject("component","model.user").init(form.userId) />

<!--- Default the validation failures to an empty struct --->
<cfset validationErrors = {} />
<!--- Are we processing the form? --->
<cfif StructKeyExists(Form,"Processing")>
	<!--- Populate the object from the form scope --->
	<cfset user.populate(form) />
	<!---
	<cfloop collection="#form#" item="fld">
		<cfif StructKeyExists(user,"set" & fld)>
			<cfinvoke component="#user#" method="set#fld#">
				<cfinvokeargument name="#fld#" value="#form[fld]#" />
			</cfinvoke>
		</cfif>
	</cfloop>
	--->
	<!--- Validate the object using ValidateThis --->
	<cfset result = application.ValidateThis.validate(objectType="User",theObject=user,Context=Form.Context) />
	<cfset validationErrors = result.getFailureMessagesByField(delimiter="<br/>") />
	<!--- If validations passed, save the record --->
	<cfif result.getIsSuccess()>
		<cfset user.save() />
		<cfset successMessage = "The User has been saved!" />
	<cfelse>
		<cfset successMessage = "" />
	</cfif>
</cfif>

<cfif Form.UserId eq 0>
	<cfset UserGroupId = 0 />
<cfelse>
	<cfset UserGroupId = user.getUserGroup().getUserGroupId() />
</cfif>

<!--- Get the list of required fields to use to dynamically add asterisks in front of each field --->
<cfset RequiredFields = application.ValidateThis.getRequiredFields(objectType="User",Context=Form.Context) />

<!--- If we want JS validations turned on, get the Script blocks to initialize the libraries and for the validations themselves, and include them in the <head> --->
<cfif NOT Form.NoJS>
	<cfset ValInit = application.ValidateThis.getInitializationScript() />
	<cfhtmlhead text="#ValInit#" />
	<!--- Some formatting rules specific to this form --->
	<cfsavecontent variable="headJS">
		<script type="text/javascript">
		jQuery(document).ready(function($) {
			jQuery.validator.setDefaults({ 
				errorClass: 'errorField', 
				errorElement: 'p', 
				errorPlacement: function(error, element) { 
					error.prependTo( element.parents('div.ctrlHolder') ) 
				}, 
				highlight: function() {}
			});
		});
		</script>
	</cfsavecontent>	
	<cfhtmlhead text="#headJS#" />
	<cfset ValidationScript = application.ValidateThis.getValidationScript(objectType="User",Context=Form.Context) />
	<cfhtmlhead text="#ValidationScript#" />
</cfif>

<cfoutput>
<h1>ValidateThis Facade Demo</h1>
<h3>#PageHeading# (JavaScript Validations are <cfif Form.NoJS>OFF<cfelse>ON</cfif>)</h3>
<cfif Len(SuccessMessage)><h3>#SuccessMessage#</h3></cfif>
<div class="formContainer">
<form action="index.cfm" id="frmMain" method="post" name="frmMain" class="uniForm">
	<input type="hidden" name="Context" id="Context" value="#Form.Context#" />
	<input type="hidden" name="NoJS" id="NoJS" value="#Form.NoJS#" />
	<input type="hidden" name="Processing" id="Processing" value="true" />
	<fieldset class="inlineLabels">	
		<legend>Access Information</legend>
		<div class="ctrlHolder">
			#isErrorMsg("UserName")#
			<label for="UserName">#isRequired("UserName")#Email Address</label>
			<input name="UserName" id="UserName" value="#trim(user.getUserName())#" size="35" maxlength="50" type="text" class="textInput" />
			<p class="formHint">Validations: Required, Must be a valid Email Address.</p>
		</div>
	</fieldset>

	<div class="buttonHolder">
		<button type="submit" class="submitButton"> Submit </button>
	</div>
</form> 

</div>
</cfoutput>

<!--- These UDFs are only required to make the demo look pretty --->
<cffunction name="isRequired" returntype="any" output="false" hint="I am used to display an asterisk for required fields.  I only exist for this demo page - there are much better ways of doing this!">
	<cfargument name="fieldName" type="any" required="yes" />
	<cfif StructKeyExists(RequiredFields,arguments.fieldName)>
		<cfreturn "<em>*</em> " />
	<cfelse>
		<cfreturn "" />
	</cfif>
</cffunction>

<cffunction name="isErrorMsg" returntype="any" output="false" hint="I am used to display error messages for a field.  I only exist for this demo page - there are much better ways of doing this!">
	<cfargument name="fieldName" type="any" required="yes" />
	<cfif StructKeyExists(validationErrors,arguments.fieldName)>
		<cfreturn '<p id="error-UserName" class="errorField bold">#validationErrors[arguments.fieldName]#</p>' />
	<cfelse>
		<cfreturn "" />
	</cfif>
</cffunction>
