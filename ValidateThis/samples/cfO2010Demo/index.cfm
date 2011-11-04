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
<cfsilent>
	<cfparam name="successMessage" default="" />
	<cfparam name="form.noJS" default="false" />
	<cfset form.noJS = not structKeyExists(url,"noJS") ? form.noJS : url.noJS />

	<!--- Reload ValidateThis - reloading on every request for the Demo --->
	<cfset ValidateThisConfig = {definitionPath="/cfO2010Demo/model/"} />
	<cfset application.VT = createObject("component","ValidateThis.ValidateThis").init(ValidateThisConfig) />

	<!--- Create a new user object to work with --->
	<cfset user = entityNew("User") />

	<!--- Are we processing the form? --->
	<cfif StructKeyExists(Form,"Processing")>
		<!--- Populate the object from the form scope --->
		<cfloop collection="#form#" item="fld">
			<cfif StructKeyExists(user,"set" & fld)>
				<cfinvoke component="#user#" method="set#fld#">
					<cfinvokeargument name="#fld#" value="#form[fld]#" />
				</cfinvoke>
			</cfif>
		</cfloop>

		<!--- Validate the object using ValidateThis --->
		<cfset result = application.VT.validate(user) />

		<!--- If validations passed, save the record --->
		<cfif result.getIsSuccess()>
			<cfset txn = ORMGetSession().beginTransaction() />
			<cftry>
				<cfset entitySave(user) />
				<cfset txn.commit() />
				<cfset successMessage = "The User has been saved!" />
				<cfcatch type="any">
					<cfset txn.rollback() />
					<cfrethrow />
				</cfcatch>
			</cftry>
		<cfelse>
			<cfset successMessage = "" />
		</cfif>
	</cfif>

</cfsilent>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
	<head>
		<title>Easy and Flexible Validations for Objects</title>
		<link href="/css/demostyle.css" type="text/css" rel="stylesheet" />
		<link href="/css/uni-form-styles.css" type="text/css" rel="stylesheet" media="all" />

		<!--- If we want JS validations turned on, get the Script blocks to initialize the libraries and for the validations themselves --->
		<cfif NOT form.noJS>

			<!--- load libraries --->
			<cfoutput>#application.VT.getInitializationScript()#</cfoutput>

			<!--- Some formatting rules specific to this form	 --->
			<script src="custom.js" type="text/javascript"></script>
			
			<!--- load validation rules --->
			<cfoutput>#application.VT.getValidationScript(objectType="User")#</cfoutput>
		
		</cfif>

	</head>

	<body>

		<cfoutput>

		<h1>Easy and Flexible Validations for Objects</h1>
		<h3>
			JavaScript Validations are <cfif form.noJS>OFF<cfelse>ON</cfif> 
			(Turn them <a href="index.cfm?NoJS=#!form.noJS#"><cfif form.noJS>ON<cfelse>OFF</cfif></a>)
		</h3>

		<!--- display a success message if the record was added, or failures otherwise --->
		<cfif Len(successMessage)>
			<h3>#successMessage#</h3>
		<cfelseif isDefined("result")>
			<!---<cfdump var="#result.getFailures()#">--->
			<cfif not result.getIsSuccess()>
				<ul>The following errors occurred:
					<cfloop array="#result.getFailures()#" index="err">
						<li>#err.message#</li>
					</cfloop>
				</ul>
			</cfif>
		</cfif>

		<div class="formContainer">
		<form action="index.cfm" id="frmMain" method="post" name="frmMain" class="uniForm">
			<input type="hidden" name="NoJS" id="NoJS" value="#form.noJS#" />
			<input type="hidden" name="Processing" id="Processing" value="true" />
			<fieldset class="inlineLabels">	
				<legend>Access Information</legend>
				<div class="ctrlHolder">
					<label for="UserName">Email Address</label>
					<input name="UserName" id="UserName" value="#user.getUserName()#" size="35" maxlength="50" type="text" class="textInput" />
					<p class="formHint">Validations: Required, Must be a valid Email Address.</p>
				</div>
				<div class="ctrlHolder">
					<label for="Nickname">Nickname</label>
					<input name="Nickname" id="Nickname" value="#user.getNickname()#" size="35" maxlength="50" type="text" class="textInput" />
					<p class="formHint">Validations: Custom - must be unique. Try 'BobRules'.</p>
				</div>
				<div class="ctrlHolder">
					<label for="UserPass">Password</label>
					<input name="UserPass" id="UserPass" value="" size="35" maxlength="50" type="password" class="textInput" />
					<p class="formHint">Validations: Required, Must be between 5 and 10 characters, Must be the same as the Verify password field.</p>
				</div>
				<div class="ctrlHolder">
					<label for="VerifyPassword">Verify Password</label>
					<input name="VerifyPassword" id="VerifyPassword" value="" size="35" maxlength="50" type="password" class="textInput" />
					<p class="formHint">Validations: Required.</p>
				</div>
			</fieldset>
		
			<fieldset class="inlineLabels">
				<legend>User Information</legend>
				<div class="ctrlHolder">
					<label for="Salutation">Salutation</label>
					<input name="Salutation" id="Salutation" value="#user.getSalutation()#" size="35" maxlength="50" type="text" class="textInput" />
					<p class="formHint">Validations: A regex ensures that only Dr, Prof, Mr, Mrs, Ms, or Miss (with or without a period) are allowed.</p>
				</div>
				<div class="ctrlHolder">
					<label for="FirstName">First Name</label>
					<input name="FirstName" id="FirstName" value="#user.getFirstName()#" size="35" maxlength="50" type="text" class="textInput" />
				</div>
				<div class="ctrlHolder">
					<label for="LastName">Last Name</label>
					<input name="LastName" id="LastName" value="#user.getLastName()#" size="35" maxlength="50" type="text" class="textInput" />
					<p class="formHint">Validations: Required if a First Name has been specified.</p>
				</div>
				<div class="ctrlHolder">
					<p class="label">Do you like Cheese?</p>
					<label for="LikeCheese-1" class="inlineLabel"><input name="LikeCheese" id="LikeCheese-1" value="1" type="radio" class=""<cfif user.getLikeCheese() EQ 1> checked="checked"</cfif> />&nbsp;Yes</label>
					<label for="LikeCheese-2" class="inlineLabel"><input name="LikeCheese" id="LikeCheese-2" value="0" type="radio" class=""<cfif user.getLikeCheese() EQ 0> checked="checked"</cfif> />&nbsp;No</label>
				</div>
				<div class="ctrlHolder">
					<p class="label">Do you like Chocolate?</p>
					<label for="LikeChocolate-1" class="inlineLabel"><input name="LikeChocolate" id="LikeChocolate-1" value="1" type="radio" class=""<cfif user.getLikeChocolate() EQ 1> checked="checked"</cfif> />&nbsp;Yes</label>
					<label for="LikeChocolate-2" class="inlineLabel"><input name="LikeChocolate" id="LikeChocolate-2" value="0" type="radio" class=""<cfif user.getLikeChocolate() EQ 0> checked="checked"</cfif> />&nbsp;No</label>
				</div>
				<div class="ctrlHolder">
					<label for="LikeOther">What do you like?</label>
					<input name="LikeOther" id="LikeOther" value="#user.getLikeOther()#" size="35" maxlength="50" type="text" class="textInput" />
					<p class="formHint">Validations: Required if neither Do you like Cheese? nor Do you like Chocolate? are true.</p>
				</div>
				<div class="ctrlHolder">
					<p class="label">Allow Communication</p>
					<label for="AllowCommunication-1" class="inlineLabel"><input name="AllowCommunication" id="AllowCommunication-1" value="1" type="radio" class=""<cfif user.getAllowCommunication() EQ 1> checked="checked"</cfif> />&nbsp;Yes</label>
					<label for="AllowCommunication-2" class="inlineLabel"><input name="AllowCommunication" id="AllowCommunication-2" value="0" type="radio" class=""<cfif user.getAllowCommunication() EQ 0> checked="checked"</cfif> />&nbsp;No</label>
				</div>
				<div class="ctrlHolder">
					<label for="CommunicationMethod">Communication Method</label>
					<select name="CommunicationMethod" id="CommunicationMethod" class="selectInput">
						<option value=""<cfif user.getCommunicationMethod() EQ ""> selected="selected"</cfif>>Select one...</option>
						<option value="Email"<cfif user.getCommunicationMethod() EQ "Email"> selected="selected"</cfif>>Email</option>
						<option value="Phone"<cfif user.getCommunicationMethod() EQ "Phone"> selected="selected"</cfif>>Phone</option>
						<option value="Pony Express"<cfif user.getCommunicationMethod() EQ "Pony Express"> selected="selected"</cfif>>Pony Express</option>
					</select>
					<p class="formHint">Validations: Required if Allow Communication? is true.</p>
				</div>
			</fieldset>
		
			<div class="buttonHolder">
				<input type="submit" class="submitButton" value="Submit" />
			</div>
		</form> 
		</div>
		</cfoutput>
	</body>
</html>

