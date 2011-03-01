<!--- this tag should only run in "end" mode ---><cfif thisTag.executionMode IS "start"><cfexit method="exittemplate" /></cfif>
<cfsilent>
<!--- 
filename:		tags/forms/field.cfm
date created:	12/14/07
author:			Matt Quackenbush (http://www.quackfuzed.com/)
purpose:		I display an XHTML 1.0 Strict form field (text, password, select, checkbox, radio) based upon the Uni-Form markup
				
	// **************************************** LICENSE INFO **************************************** \\
	
	Copyright 2007, Matt Quackenbush
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
	// ****************************************** REVISIONS ****************************************** \\
	
	DATE		DESCRIPTION OF CHANGES MADE												CHANGES MADE BY
	===================================================================================================
	12/14/07		New																				MQ
	
	6/1/08			Added support for jQuery's Masked-Input plugin.									MQ
					Added support for jQuery's form validation plugin.
					Added support for additional class(es) to be set on the field's holder div.
	
	7/11/08			Added support for isChecked on checkboxes.										MQ
	
	9/8/08			Deprecated the 'addClass' attribute and added 									MQ
						support for 'containerClass' and 'inputClass'
	
	9/22/08			Deprecated the 'textareaRows' and 'textareaCols' attributes						MQ
	
	9/22/08			Added support for jQuery's PrettyComments plugin 					Bob Silverberg
						 (textarea resizing)
	
	9/30/08			Added 'pluginSetup' attribute, used for passing field-specific 					MQ
						setup instructions to jQuery plugins.
	
	11/12/08		Behavior change for the 'label' attribute.  It is now optional, 	Bob Silverberg
						and defaults to the value of the 'name' attribute.
	
	2/19/09			Removed support for previously deprecated attributes:							MQ
							textareaRows
							textareaCols
							addClass
					
	2/19/09			Removed support for the isInline attribute, because of changes					MQ
						in the Uni-Form CSS.
					
	2/19/09			Deprecated the validation attribute. Use @inputClass instead.					MQ
	
 --->

<!--- // use example
	
	// REQUIRED ATTRIBUTES
	@type					Required (string)		- The type of form field to display.  Acceptable values are:
																text
																password
																checkboxgroup
																checkbox
																radio
																textarea
																select
																custom
																date
																time
	@name					Required unless type="custom" (string)		- The name of the field.  Used in the id="" and name="" attribute.
	
	// OPTIONAL ATTRIBUTES
	@label					Optional (string)		- The text to display as a label for the field.  Used in the <label></label> tag.
															Defaults to the value of the name attribute.
	@value					Optional (string)		- The value of the field.  Defaults to an empty string.
	@hint					Optional (string) 		- help text to display for the field
	@errorMessage			Optional (string) 		- the error message to display (used after failed validation)
	@isRequred				Optional (boolean)	- indicates whether or not the field is required
																				defaults to 'false'
	@isDisabled				Optional (boolean)	- indicates whether or not the field is enabled (supplying a value of 'true' will set disabled="disabled" on the field)
																				defaults to 'false'
	@isChecked				Optional (boolean)	- indicates whether or not the checkbox is checked; ignored unless type="checkbox"
																				defaults to 'false'
	@fieldSize				Optional (numeric)	- used in the size="" attribute of <input /> tags
																				defaults to 35
	@maxFieldLength			Optional (numeric)	- used in the maxlength="" attribute of <input /> tags
																				defaults to 50
	@textareaResizable		Optional (boolean)	- indicates whether or not the text area should be resizable
																		defaults to 'true'
													NOTE: This attribute is completely ignore unless type="textarea" AND 
															the 'loadTextareaResizable' attribute is provided to the form (and set to true).
	@containerClass			Optional (string) 			- additional class attributes for the the holder div of the field.
	@inputClass				Optional (string) 			- additional class attributes for the input tag of the field.
	@mask					Optional(string)			- The mask to which the field must conform.  Used in conjunction with 
																jQuery's Masked Input plugin.
	@validation				DEPRACATED (2/19/09) MQ 	- One should add validation class rules via the 'inputClass' attribute.
	@pluginSetup			Optional(string)			- Field-specific setup instructions to pass to a jQuery plugin. 
																ex. type="date" pluginSetup="{ yearRange: '2000:2010' }" 
																The line above would have the year drop down rendered by 
																the datepicker plugin display the years 2000-2010.  It 
																would only affect this particular field, allowing you to 
																pass different values to different date fields in your form.
	
	// STEPS TO USE THIS TAG
		
		For more info on all of the steps, see the "use example" comments in the UniForm Form.cfm tag.
		This tag is used in Step 3 of the form building process.
		
		type="text"
			
			<uform:field label="Email Address" name="emailAddress" isRequired="true" type="text" value="" hint="Note: Your email is your username.  Use a valid email address."  />
			
		type="password"
			
			<uform:field label="Choose Password" name="password" isRequired="true" type="password" value=""  />
			
		type="radio"
			
			<uform:field label="Gender" name="gender" type="radio"> <------- this here is how you're calling this tag!!!
				<uform:radio label="Male" value="1" />
				<uform:radio label="Female" value="2" />
			</uform:field>
		
		type="checkboxgroup"
			
			<uform:field label="Display Options" name="displayOptions" type="checkboxgroup"> <------- this here is how you're calling this tag!!!
				<uform:checkbox label="Display my email address" value="email" />
				<uform:checkbox label="Display my picture" value="pic" />
			</uform:field>
			
		type="checkbox"
			
			<uform:field label="Send me your news and information (a.k.a. junk)" name="newsletter" value="1" type="checkbox"  />
			
		type="textarea"
			
			<uform:field label="About You" name="aboutYou" type="textarea" value="" hint="Tell us something about yourself in 300 words or less."  />
			
		type="select"
			
			<uform:field label="A Select Box" name="selectbox" type="select"> <------- this here is how you're calling this tag!!!
				<option value="1">Option A</option>
				<option value="2">Option B</option>
				<option value="3">Option C</option>
				<option value="4">Option D</option>
				<option value="5">Option E</option>
			</uform:field>
			
		type="file"
			
			<uform:field label="Upload Picture" name="upload" type="file" hint="Your image will be resized to 80x80 pixels."  />
		
		type="custom"
			
			<uform:field type="custom">
				// anything you want to display here.
			</uform:field>
		
 --->


<!--- define the tag attributes --->
	<!--- required attributes --->
	<cfparam name="attributes.type" type="string" />
	
	<!--- optional attributes --->
	<cfparam name="attributes.name" type="string" default="" />
	<cfparam name="attributes.label" type="string" default="#attributes.name#" />
	<cfparam name="attributes.value" type="string" default="" />
	<cfparam name="attributes.hint" type="string" default="" />
	<cfparam name="attributes.isRequired" type="boolean" default="no" />
	<cfparam name="attributes.isDisabled" type="boolean" default="no" />
	<cfparam name="attributes.isChecked" type="boolean" default="no" />
	<cfparam name="attributes.fieldSize" type="numeric" default="35" />
	<cfparam name="attributes.maxFieldLength" type="numeric" default="50" />
	<cfparam name="attributes.textareaResizable" type="boolean" default="yes" />
	<cfparam name="attributes.containerClass" type="string" default="" />
	<cfparam name="attributes.inputClass" type="string" default="" />
	<cfparam name="attributes.mask" type="string" default="" />
	<cfparam name="attributes.validation" type="string" default="" /><!--- deprecated in v3.0 (2/19/09) --->
	<cfparam name="attributes.pluginSetup" type="string" default="" />
	<cfparam name="attributes.content" type="string" default="" /><!--- do not supply this attribute; it is used internally --->

<!--- make sure that we have a label and a name if the type is not "custom" --->
<cfif (attributes.type IS NOT "custom") AND (len(trim(attributes.name)) EQ 0)>
	<cfthrow type="tags.forms.cfUniForm.field.incomplete" detail="You *must* supply the 'name' argument with type='#attributes.type#'" />
</cfif>

<cfscript>
	// if tag has content nested inside
	if ( len(trim(thisTag.generatedContent)) ) {
		/*
		*	add content as a tag attribute so its available to fieldset tag, 
		*		and reset generatedContent so nothing is rendered
		*/
		attributes.content = trim(thisTag.generatedContent);
		thisTag.generatedContent = "";
	}
	// does tag have any optiongroups associated with it?
	if ( structKeyExists(thisTag, "optiongroups") ) {
		// pass them on in the attributes
		attributes.optiongroups = thisTag.optiongroups;
	}
	// does tag have any options associated with it?
	if ( structKeyExists(thisTag, "options") ) {
		// pass them on in the attributes
		attributes.options = thisTag.options;
	}
	// does tag have any radios associated with it?
	if ( structKeyExists(thisTag, "radios") ) {
		// pass them on in the attributes
		attributes.radios = thisTag.radios;
	}
	// does tag have any checkboxes associated with it?
	if ( structKeyExists(thisTag, "checkboxes") ) {
		// pass them on in the attributes
		attributes.checkboxes = thisTag.checkboxes;
	}
</cfscript>

<cfassociate basetag="cf_fieldset" datacollection="fields" />
</cfsilent>
