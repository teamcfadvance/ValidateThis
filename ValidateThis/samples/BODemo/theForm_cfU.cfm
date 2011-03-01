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
<cfparam name="SuccessMessage" default="" />

<cfif Form.Context EQ "Profile">
	<cfset PageHeading = "Editing an existing User" />
	<cfset Form.UserId = 1 />
<cfelse>
	<cfset PageHeading = "Registering a new User" />
</cfif>

<!--- We need the UserService to get our Business Object and to Perform an Update --->
<cfset UserService = application.BeanFactory.getBean("UserService") />
<!--- Default the validation errors to an empty struct, to pass to <uform:form> --->
<cfset UniFormErrors = StructNew() />
<!--- Are we displaying a form or processing a form? --->
<cfif StructKeyExists(Form,"Processing")>
	<cfset Result = UserService.updateUser(theId=Form.UserId,args=Form,Context=Form.Context) />
	<cfset UniFormErrors = Result.getFailuresForUniForm() />
	<cfset SuccessMessage = Result.getSuccessMessage() />
	<cfset UserTO = Result.getTheObject() />
<cfelse>
	<cfset UserTO = UserService.getUser(theId=Form.UserId) />
</cfif>
<cfif UserTO.hasUserGroup()>
	<cfset UserGroupId = UserTO.getUserGroup().getUserGroupId() />
<cfelse>
	<cfset UserGroupId = 0 />
</cfif>

<!--- Get the list of required fields and field descriptions from the Business Object to use for cfUniForm custom tags --->
<cfset RequiredFields = UserTO.getRequiredFields(Form.Context) />
<cfset FieldLabels = UserTO.getValidationClientFieldDescs() />

<!--- If we want JS validations turned on, get the Script block for JavaScript validations, and include it in the <head> --->
<cfif NOT Form.NoJS>
	<cfset ValInit = UserTO.getInitializationScript() />
	<cfhtmlhead text="#ValInit#" />
	<!--- Some formatting rules specific to this form --->
	<cfsavecontent variable="headJS">
		<script src="validatethis/samples/commonassets/scripts/jQuery/forms/uni-form.jquery.js" type="text/javascript"></script>
	</cfsavecontent>	
	<cfhtmlhead text="#headJS#" />
	<cfset ValidationScript = UserTO.getValidationScript(Form.Context) />
	<cfhtmlhead text="#ValidationScript#" />
</cfif>

<!--- Create the form using cfUniForm custom tags --->
<cfimport taglib="/validateThis/samples/BODemo/tags/forms/cfUniForm/" prefix="uform" />

<cfoutput>
<h1>ValidateThis Integrated BO Demo - with Transfer and cfUniForm</h1>
<h3>#PageHeading# (JavaScript Validations are <cfif Form.NoJS>OFF<cfelse>ON</cfif>)</h3>
<cfif Len(SuccessMessage)><h3>#SuccessMessage#</h3></cfif>
<div class="formContainer">
<uform:form action="index.cfm?cfU=_cfU" 
				id="frmMain" 
				showCancel="false" 
				requiredFields="#RequiredFields#"
				fieldLabels="#FieldLabels#"
				errors="#UniFormErrors#"
				errorMessagePlacement="inline">
	<uform:fieldset legend="Access Information">
		<uform:field type="custom">
			<input type="hidden" name="Context" id="Context" value="#Form.Context#" />
			<input type="hidden" name="NoJS" id="NoJS" value="#Form.NoJS#" />
			<input type="hidden" name="Processing" id="Processing" value="true" />
		</uform:field>
		<uform:field 
					name="UserName" 
					type="text" 
					value="#UserTO.getUserName()#"
					hint="Validations: Required, Must be a valid Email Address." />
		<uform:field 
					name="Nickname" 
					type="text" 
					value="#UserTO.getNickname()#"
					hint="Validations: Custom - must be unique. Try 'BobRules'." />
		<uform:field 
					name="UserPass" 
					type="password"
					hint="Validations: Required, Must be between 5 and 10 characters, Must be the same as the Verify password field." />
		<uform:field 
					name="VerifyPassword" 
					type="password"
					hint="Validations: Required." />
		<uform:field 
					name="UserGroupId" 
					type="select"
					hint="Validations: Required.">
			<uform:option display="Select one..." 
					value="" />
			<uform:option display="Member" 
					value="1"
					isSelected="#UserGroupId EQ 1#" />
			<uform:option display="Administrator" 
					value="2"
					isSelected="#UserGroupId EQ 2#" />
		</uform:field>
	</uform:fieldset>

	<uform:fieldset legend="User Information">
		<uform:field 
					name="Salutation" 
					type="text" 
					value="#UserTO.getSalutation()#"
					hint="Validations: A regex ensures that only Dr, Prof, Mr, Mrs, Ms, or Miss (with or without a period) are allowed." />
		<uform:field 
					name="FirstName" 
					type="text" 
					value="#UserTO.getFirstName()#"
					hint="Validations: Required on Update." />
		<uform:field 
					name="LastName" 
					type="text" 
					value="#UserTO.getLastName()#"
					hint="Validations: Required on Update OR if a First Name has been specified during Register." />
		<uform:field label="Do you like Cheese?" name="LikeCheese" type="radio">
			<uform:radio label="Yes" value="1" isChecked="#UserTO.getLikeCheese() EQ 1#" />
			<uform:radio label="No" value="0" isChecked="#UserTO.getLikeCheese() EQ 0#" />
		</uform:field>
		<uform:field label="Do you like Chocolate?" name="LikeChocolate" type="radio">
			<uform:radio label="Yes" value="1" isChecked="#UserTO.getLikeChocolate() EQ 1#" />
			<uform:radio label="No" value="0" isChecked="#UserTO.getLikeChocolate() EQ 0#" />
		</uform:field>
		<uform:field 
					name="LikeOther" 
					type="text" 
					value="#UserTO.getLikeOther()#"
					hint="Validations: Required if neither Do you like Cheese? nor Do you like Chocolate? are true." />
		<uform:field 
					name="HowMuch" 
					type="text" 
					value="#UserTO.getHowMuch()#"
					hint="Validations: Numeric - notice that an invalid value is redisplayed upon server side validation failure." />
		<uform:field name="AllowCommunication" type="radio">
			<uform:radio label="Yes" value="1" isChecked="#UserTO.getAllowCommunication() EQ 1#" />
			<uform:radio label="No" value="0" isChecked="#UserTO.getAllowCommunication() EQ 0#" />
		</uform:field>
		<uform:field 
					name="CommunicationMethod" 
					type="select"
					hint="Validations: Required if Allow Communication? is true.">
			<uform:option display="Select one..." value="" />
			<uform:option display="Email" value="Email" isSelected="#UserTO.getCommunicationMethod() EQ 'Email'#" />
			<uform:option display="Phone" value="Phone" isSelected="#UserTO.getCommunicationMethod() EQ 'Phone'#" />
			<uform:option display="Pony Express" value="Pony Express" isSelected="#UserTO.getCommunicationMethod() EQ 'Pony Express'#" />
		</uform:field>
	</uform:fieldset>
</uform:form>
</div>
</cfoutput>

