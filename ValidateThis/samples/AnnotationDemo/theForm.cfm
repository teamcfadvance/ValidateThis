<!---
	
	Copyright 2010, Bob Silverberg
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
--->
<cfparam name="successMessage" default="" />

<cfif form.context EQ "Profile">
	<cfset pageHeading = "Editing an existing User" />
	<cfset form.userId = 1 />
	<cfset user = entityLoadByPK("User",form.userId) />
	<cfset userGroupId = user.getUserGroup().getUserGroupId() />
<cfelse>
	<cfset pageHeading = "Registering a new User" />
	<cfset user = entityNew("User") />
	<cfset userGroupId = 0 />
</cfif>

<!--- Default the validation failures to an empty struct --->
<cfset uniFormErrors = {} />
<!--- Are we processing the form? --->
<cfif StructKeyExists(form,"processing")>
	<!--- Populate the object from the form scope --->
	<cfset userGroupId = form.userGroupId />
	<cfloop collection="#form#" item="fld">
		<cfif StructKeyExists(user,"set" & fld) and (fld neq "userId" or val(form[fld]) gt 0)>
			<cfinvoke component="#user#" method="set#fld#">
				<cfinvokeargument name="#fld#" value="#form[fld]#" />
			</cfinvoke>
		</cfif>
	</cfloop>
	<!--- Validate the object using ValidateThis --->
	<cfset result = application.validateThis.validate(theObject=user,context=form.context) />
	<cfset uniFormErrors = result.getFailuresForUniForm() />
	<!--- If validations passed, save the record --->
	<cfif result.getIsSuccess()>
		<cftransaction>
			<cfset entitySave(user) />
		</cftransaction>
		<cfset successMessage = "The User has been saved!" />
	<cfelse>
		<cfset successMessage = "" />
	</cfif>
</cfif>

<!--- Get the list of required fields to use to dynamically add asterisks in front of each field --->
<cfset requiredFields = application.validateThis.getRequiredFields(theObject=user,context=form.context) />

<!--- If we want JS validations turned on, get the Script blocks to initialize the libraries and for the validations themselves, and include them in the <head> --->
<cfif NOT form.NoJS>
	<cfset valInit = application.validateThis.getInitializationScript() />
	<cfhtmlhead text="#valInit#" />
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
	<cfset validationScript = application.validateThis.getValidationScript(theObject=user,context=form.context) />
	<cfhtmlhead text="#validationScript#" />
</cfif>
<cfoutput>
<h1>ValidateThis Annotation Demo - using CF9 ORM and JSON Format annotations</h1>
<h3>#pageHeading# (JavaScript Validations are <cfif form.NoJS>OFF<cfelse>ON</cfif>)</h3>
<cfif Len(successMessage)><h3>#successMessage#</h3></cfif>
<div class="formContainer">
<form action="index.cfm" id="frm#form.context#" method="post" name="frm#form.context#" class="uniForm">
	<input type="hidden" name="context" id="context" value="#form.context#" />
	<input type="hidden" name="noJS" id="noJS" value="#form.noJS#" />
	<input type="hidden" name="processing" id="processing" value="true" />
	<fieldset class="inlineLabels">	
		<legend>Access Information</legend>
		<div class="ctrlHolder">
			#isErrorMsg("userName")#
			<label for="userName">#isRequired("userName")#Email Address</label>
			<input name="userName" id="userName" value="#user.getUserName()#" size="35" maxlength="50" type="text" class="textInput" />
			<p class="formHint">Validations: Required, Must be a valid Email Address.</p>
		</div>
		<div class="ctrlHolder">
			#isErrorMsg("nickname")#
			<label for="nickname">#isRequired("nickname")#nickname</label>
			<input name="nickname" id="nickname" value="#user.getNickname()#" size="35" maxlength="50" type="text" class="textInput" />
			<p class="formHint">Validations: Custom - must be unique. Try 'BobRules'.</p>
		</div>
		<div class="ctrlHolder">
			#isErrorMsg("userPass")#
			<label for="userPass">#isRequired("userPass")#Password</label>
			<input name="userPass" id="userPass" value="" size="35" maxlength="50" type="password" class="textInput" />
			<p class="formHint">Validations: Required, Must be between 5 and 10 characters, Must be the same as the Verify password field.</p>
		</div>
		<div class="ctrlHolder">
			#isErrorMsg("verifyPassword")#
			<label for="verifyPassword">#isRequired("verifyPassword")#Verify Password</label>
			<input name="verifyPassword" id="verifyPassword" value="" size="35" maxlength="50" type="password" class="textInput" />
			<p class="formHint">Validations: Required.</p>
		</div>
		<div class="ctrlHolder">
			#isErrorMsg("userGroupId")#
			<label for="userGroupId">#isRequired("userGroupId")#User Group</label>
			<select name="userGroupId" id="userGroupId" class="selectInput">
				<option value=""<cfif userGroupId EQ ""> selected="selected"</cfif>>Select one...</option>
				<option value="1"<cfif userGroupId EQ 1> selected="selected"</cfif>>Member</option>
				<option value="2"<cfif userGroupId EQ 2> selected="selected"</cfif>>Administrator</option>
			</select>
			<p class="formHint">Validations: Required.</p>
		</div>
	</fieldset>

	<fieldset class="inlineLabels">
		<legend>User Information</legend>
		<div class="ctrlHolder">
			#isErrorMsg("salutation")#
			<label for="salutation">#isRequired("salutation")#Salutation</label>
			<input name="salutation" id="salutation" value="#user.getSalutation()#" size="35" maxlength="50" type="text" class="textInput" />
			<p class="formHint">Validations: A regex ensures that only Dr, Prof, Mr, Mrs, Ms, or Miss (with or without a period) are allowed.</p>
		</div>
		<div class="ctrlHolder">
			#isErrorMsg("firstName")#
			<label for="firstName">#isRequired("firstName")#First Name</label>
			<input name="firstName" id="firstName" value="#user.getFirstName()#" size="35" maxlength="50" type="text" class="textInput" />
			<p class="formHint">Validations: Required on Update.</p>
		</div>
		<div class="ctrlHolder">
			#isErrorMsg("lastName")#
			<label for="lastName">#isRequired("lastName")#Last Name</label>
			<input name="lastName" id="lastName" value="#user.getLastName()#" size="35" maxlength="50" type="text" class="textInput" />
			<p class="formHint">Validations: Required on Update OR if a First Name has been specified during Register.</p>
		</div>
		<div class="ctrlHolder">
			#isErrorMsg("likeCheese")#
			<p class="label">#isRequired("likeCheese")#Do you like Cheese?</p>
			<label for="likeCheese-1" class="inlineLabel"><input name="likeCheese" id="likeCheese-1" value="1" type="radio" class=""<cfif user.getLikeCheese() EQ 1> checked="checked"</cfif> />&nbsp;Yes</label>
			<label for="likeCheese-2" class="inlineLabel"><input name="likeCheese" id="likeCheese-2" value="0" type="radio" class=""<cfif user.getLikeCheese() EQ 0> checked="checked"</cfif> />&nbsp;No</label>
		</div>
		<div class="ctrlHolder">
			#isErrorMsg("likeChocolate")#
			<p class="label">#isRequired("likeChocolate")#Do you like Chocolate?</p>
			<label for="likeChocolate-1" class="inlineLabel"><input name="likeChocolate" id="likeChocolate-1" value="1" type="radio" class=""<cfif user.getLikeChocolate() EQ 1> checked="checked"</cfif> />&nbsp;Yes</label>
			<label for="likeChocolate-2" class="inlineLabel"><input name="likeChocolate" id="likeChocolate-2" value="0" type="radio" class=""<cfif user.getLikeChocolate() EQ 0> checked="checked"</cfif> />&nbsp;No</label>
		</div>
		<div class="ctrlHolder">
			#isErrorMsg("likeOther")#
			<label for="likeOther">#isRequired("likeOther")#What do you like?</label>
			<input name="likeOther" id="likeOther" value="#user.getLikeOther()#" size="35" maxlength="50" type="text" class="textInput" />
			<p class="formHint">Validations: Required if neither Do you like Cheese? nor Do you like Chocolate? are true.</p>
		</div>
		<div class="ctrlHolder">
			#isErrorMsg("howMuch")#
			<label for="howMuch">#isRequired("howMuch")#How much money would you like?</label>
			<input name="howMuch" id="howMuch" value="#user.getHowMuch()#" size="35" maxlength="50" type="text" class="textInput" />
			<p class="formHint">Validations: Numeric - notice that an invalid value is redisplayed upon server side validation failure.</p>
		</div>
		<div class="ctrlHolder">
			#isErrorMsg("allowCommunication")#
			<p class="label">#isRequired("allowCommunication")#Allow Communication</p>
			<label for="allowCommunication-1" class="inlineLabel"><input name="allowCommunication" id="allowCommunication-1" value="1" type="radio" class=""<cfif user.getAllowCommunication() EQ 1> checked="checked"</cfif> />&nbsp;Yes</label>
			<label for="allowCommunication-2" class="inlineLabel"><input name="allowCommunication" id="allowCommunication-2" value="0" type="radio" class=""<cfif user.getAllowCommunication() EQ 0> checked="checked"</cfif> />&nbsp;No</label>
		</div>
		<div class="ctrlHolder">
			#isErrorMsg("communicationMethod")#
			<label for="communicationMethod">#isRequired("communicationMethod")#Communication Method</label>
			<select name="communicationMethod" id="communicationMethod" class="selectInput">
				<option value=""<cfif user.getCommunicationMethod() EQ ""> selected="selected"</cfif>>Select one...</option>
				<option value="Email"<cfif user.getCommunicationMethod() EQ "Email"> selected="selected"</cfif>>Email</option>
				<option value="Phone"<cfif user.getCommunicationMethod() EQ "Phone"> selected="selected"</cfif>>Phone</option>
				<option value="Pony Express"<cfif user.getCommunicationMethod() EQ "Pony Express"> selected="selected"</cfif>>Pony Express</option>
			</select>
			<p class="formHint">Validations: Required if Allow Communication? is true.</p>
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
	<cfif StructKeyExists(requiredFields,arguments.fieldName)>
		<cfreturn "<em>*</em> " />
	<cfelse>
		<cfreturn "" />
	</cfif>
</cffunction>

<cffunction name="isErrorMsg" returntype="any" output="false" hint="I am used to display error messages for a field.  I only exist for this demo page - there are much better ways of doing this!">
	<cfargument name="fieldName" type="any" required="yes" />
	<cfif StructKeyExists(uniFormErrors,arguments.fieldName)>
		<cfreturn '<p id="error-userName" class="errorField bold">#uniFormErrors[arguments.fieldName]#</p>' />
	<cfelse>
		<cfreturn "" />
	</cfif>
</cffunction>
