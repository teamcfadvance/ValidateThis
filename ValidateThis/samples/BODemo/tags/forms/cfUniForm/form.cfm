<cfsilent>
<!--- EDITABLE CONFIG SETTINGS ON LINE 171 --->
<!--- 
filename:			tags/forms/form.cfm
date created:	10/22/07
author:			Matt Quackenbush (http://www.quackfuzed.com)
purpose:			I display an XHTML 1.0 Strict form based upon the Uni-Form markup
				
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
	10/22/07		New																				MQ
	
	6/1/08			Added support for auto-loading of CSS/JS prerequisites.							MQ
					Added support for jQuery's masked-input plugin.
					Added support for jQuery's datepicker plugin - enhancement submitted by Dan Wilson.
					Added support for jQuery's timeentry plugin - enhancement submitted by Dan Wilson.
					
	7/15/08			Added support for optional error message placement								MQ
	
	9/22/08			Added support for jQuery's PrettyComments plugin					Bob Silverberg
						 (textarea resizing)
	
	9/29/08			Added support for loading plugin setups for jQuery's 							MQ
						 datepicker, timeentry, and validation plugins
	
	11/12/08		Added support for passing in a struct of field labels,				Bob Silverberg
						in support of integration with ValidateThis.
						http://validatethis.riaforge.org/
						http://www.silverwareconsulting.com/index.cfm/ValidateThis
	
	11/12/08		Added support for plugin setups to be passed in via the config  				MQ
						 attribute - enhancement submitted by Dan Wilson
	
	12/11/08		Added support for the second submit button to be floated left.  				MQ
						 Useful for having a "Back" button in a wizard application.
	
	1/15/09			Bug fix: IE has an issue with enctype on an empty form, so the   				MQ
						 enctype is now dynamically set.
	
	2/19/09			Complete v3.0 update.  Updated paths to css/script files.  Added 				MQ
						 new uniformCSSie config argument since the new Uni-Form 
						 markup/CSS requires IE-specific rules.  Added new okMsg 
						 attribute for supplying a success message.  Updated to latest 
						 jQuery, validation plugin, masked input plugin, time entry 
						 plugin releases.
	
	2/26/09			Bug fix: When validation rules were added via the validationSetup				MQ
						 attribute, clicking the cancel button would still cause 
						 validation routines to run.  The cancel button now bypasses 
						 validation.
	
	2/26/09			Added the 'cancelAction' attribute, which supports a client-side 				MQ
						 javascript redirect to the URL provided to this attribute.
	
 --->

<!--- // use example
	
	// REQUIRED ATTRIBUTES
	@action					Required (string)		The path to be supplied to the action="" attribute of the form tag
	@id							Required (string)		The form ID (goes into the id="" attribute of the form tag)
	
	// OPTIONAL ATTRIBUTES
	@loadDateUI			Optional (boolean)	Indicates whether or not to load the prerequisite files for the jQuery UI datepicker plugin.
																			Defaults to false.
	@dateSetup			Optional (string)	Commands to load for the jQuery UI datepicker plugin.
																			Defaults to an empty string.
	@loadTimeUI			Optional (boolean)	Indicates whether or not to load the prerequisite files for the jQuery time entry plugin.
																			Defaults to false.
	@timeSetup			Optional (string)	Commands to load for jQuery's time entry plugin.
																			Defaults to an empty string.
	@loadMaskUI			Optional (boolean)	Indicates whether or not to load the prerequisite files for the jQuery masked input plugin.
																			Defaults to false.
	@loadValidation		Optional (boolean)	Indicates whether or not to load the prerequisite files for the jQuery form validation plugin.
																			Defaults to false.
	@validationSetup	Optional (string)	Commands to load for jQuery's validation plugin.
																			Defaults to an empty string.
	@loadjQuery			Optional (boolean)	Indicates whether or not to load the jQuery core library.
																			Defaults to false.
	@loadTextareaResize		Optional (boolean)	Indicates whether or not to load the prerequisite files for the jQuery PrettyComments plugin.
																			Defaults to false.
	@textareaMaxHeight		Optional (numeric)	value to use for MaxHeight parameter of AutoResizable textarea
																			Defaults to 500.
	@texareaSetup			Optional (string)	- Setup parameters for the textareaResize (prettyComments) plugin.
														Defaults to: {maxHeight: 500}
	@errors				Optional (struct|array)	A struct or an array of validation error messages to display.
													If passing a struct, each key should match a field name 
													on the form, with its value being the error message.
														e.g. myErrors = structNew();
															 myErrors.userName = "The User Name is invalid.";
													
													If passing an array, each index of the array *must* 
													contain a struct with two keys:
													
														1) property
														2) message
													
													The 'property' key should match the offending field name on the form.
													The 'message' key is the error message that will be displayed.
														e.g. myErrors = arrayNew(1);
															 struct = structNew();
															 struct.property = "UserName";
															 struct.message = "The User Name is invalid.";
															 arrayAppend(myErrors, struct);
													
													An exception will be thrown if the array does not 
													meet the above specification.
	@errorTitle			Optional (string)		The title to display above the error messages. Defaults to:
																			"Ooooops!  Invalid Fields!"
	@errorMessage		Optional (string)		The message to display above the error messages. Defaults to:
																			"The following errors were detected in your form. 
																			 Please fix the offending fields and re-submit."
	@errorMessagePlacement	Optional (string)	Indicates where to display the error messages (if any).  Valid options are:
																			top
																			inline
																			both (default)
																			none
	@errorListType		Optional (string)		The type of (HTML) list to use in displaying validation errors.  
																			Acceptable values are: 
																				ol
																				ul
																			Defaults to 'ul'.
	@method					Optional (string)		The form method; either 'post' or 'get'.  Defaults to 'post'.
	@showCancel			Optional (boolean)	Indicates whether or not to show a 'Cancel' button.
																			Defaults to true.
	@cancelValue			Optional (string)		The text to show on the 'Cancel' button.  Defaults to ' Cancel '.
	@cancelAction			Optional (string)		The URL that JavaScript will direct the browser to if the 'Cancel' button is clicked.  
														Can be a full URL (e.g. 'http://www.domain.com/index.cfm') or a file (e.g. 'index.cfm').  
														If not provided, or is an empty string, the form will be submitted normally.
															Defaults to an empty string.
	@submitValue			Optional (string)		The text to show on the 'Submit' button.  Defaults to ' Submit '.
	@showReset			Optional (boolean)	Indicates whether or not to show a 'Reset' button.
																			Defaults to false.
	@resetValue			Optional (string)		The text to show on the 'Reset' button.  Defaults to ' Reset '.
	@submit2name			Optional (string)		The name/id of a second submit button.  If not provided (or if an empty string is provided), 
															a second submit button will *not* be displayed.
	@submit2value			Optional (string)		The text to show on the second submit button.
	@submit2placement			Optional (string)	Indicates whether the second submit button should appear on the far left, 
														immediately before or immediately after the standard one.
														Valid values are: 
																before
																after
																left
														Defaults to 'before'.
	
	// STEPS TO USE THIS TAG
	
		Step 1: load the uform tags
			
			<cfimport taglib="/tags/forms/cfUniForm" prefix="uform" />
			
		Step 2: open the form
			
			<uform:form action="myAction.cfm" method="post" id="myForm">
			
		Step 3: add the form elements
			
			for more info on Step 3, see the "use example" comments in the following tags:
				- fieldset.cfm
				- field.cfm
				- option.cfm
				- checkbox.cfm
				- radio.cfm
				- countryCodes.cfm
				- states-us.cfm
				- states-can.cfm
			
		Step 4: close the form
			
			</uform:form>
	
	// SIMPLE EXAMPLE
		
		<cfimport taglib="/tags/forms/cfUniForm" prefix="uform" /> <-------- Step 1
		<uform:form action="myAction.cfm" method="post" id="myForm"> <------- Step 2
			<uform:fieldset legend="Required Fields" class="inlineLabels"> <--------- Step 3 (NOTE: next four lines are part of this step)
				<uform:field label="Email Address" name="emailAddress" isRequired="true" type="text" value="" hint="Note: Your email is your username.  Use a valid email address."  />
				<uform:field label="Choose Password" name="password" isRequired="true" type="password" value=""  />
				<uform:field label="Re-enter Password" name="password2" isRequired="true" type="password" value=""  />
			</uform:fieldset>
		</uform:form> <--------------------------------------------------------------------- Step 4
		
 --->

<!--- config settings --->
<cfscript>
	_config = structNew();
	_config.jQuery = "/commonassets/scripts/jQuery/jQuery-1.3.2.min.js";
	_config.renderer = "../renderValidationErrors.cfm";
	_config.uniformCSS = "/commonassets/css/uni-form.css";
	_config.uniformCSSie = "/commonassets/css/uni-form-ie.css";
	_config.uniformJS = "/commonassets/scripts/jQuery/forms/uni-form.jquery.js";
	_config.validationJS = "/commonassets/scripts/jQuery/forms/jquery.validate-1.5.1.min.js";
	_config.dateCSS = "/commonassets/css/jquery.ui.datepicker.css";
	_config.dateJS = "/commonassets/scripts/jQuery/forms/ui.datepicker.packed.js";
	_config.timeCSS = "/commonassets/css/jquery.timeentry.css";
	_config.timeJS = "/commonassets/scripts/jQuery/forms/jquery.timeentry-1.4.2.min.js";
	_config.maskJS = "/commonassets/scripts/jQuery/forms/jquery.maskedinput-1.2.1.pack.js";
	_config.textareaJS = "/commonassets/scripts/jQuery/forms/jquery.prettyComments-1.4.js";
</cfscript>

<!--- SHOULD BE NO NEED TO EDIT BELOW THIS LINE --->
<!--- define the tag attributes --->
	<!--- required attributes --->
	<cfparam name="attributes.action" type="string" />
	<cfparam name="attributes.id" type="string" />
	
	<!--- optional attributes --->
	<cfparam name="attributes.loadDateUI" type="boolean" default="no" />
	<cfparam name="attributes.loadTimeUI" type="boolean" default="no" />
	<cfparam name="attributes.loadMaskUI" type="boolean" default="no" />
	<cfparam name="attributes.loadValidation" type="boolean" default="no" />
	<cfparam name="attributes.loadjQuery" type="boolean" default="no" />
	<cfparam name="attributes.loadTextareaResize" type="boolean" default="no" />
	<cfparam name="attributes.textareaMaxHeight" type="numeric" default="500" />
	<cfparam name="attributes.textareaSetup" type="string" default="" />
	<cfparam name="attributes.timeSetup" type="string" default="" />
	<cfparam name="attributes.dateSetup" type="string" default="" />
	<cfparam name="attributes.validationSetup" type="string" default="" />
	<cfparam name="attributes.errors" type="any" default="#structNew()#" />
	<cfparam name="attributes.errorTitle" type="string" default="Oooops!  Invalid Fields!" />
	<cfparam name="attributes.errorMessage" type="string" default="The following errors were detected in your form.  Please fix the offending fields and re-submit." />
	<cfparam name="attributes.errorMessagePlacement" type="string" default="both" />
	<cfparam name="attributes.errorListType" type="string" default="ul" />
	<cfparam name="attributes.okMsg" type="string" default="" />
	<cfparam name="attributes.method" type="string" default="post" />
	<cfparam name="attributes.showSubmit" type="boolean" default="yes" />
	<cfparam name="attributes.showCancel" type="boolean" default="yes" />
	<cfparam name="attributes.cancelValue" type="string" default=" Cancel " />
	<cfparam name="attributes.cancelAction" type="string" default="" />
	<cfparam name="attributes.submitValue" type="string" default=" Submit " />
	<cfparam name="attributes.showReset" type="boolean" default="no" />
	<cfparam name="attributes.resetValue" type="string" default=" Reset " />
	<cfparam name="attributes.submitButtonAddClass" type="string" default="" />
	<cfparam name="attributes.submit2name" type="string" default="" />
	<cfparam name="attributes.submit2value" type="string" default="" />
	<cfparam name="attributes.submit2placement" type="string" default="before" />
	<cfparam name="attributes.requiredFields" type="struct" default="#structNew()#" />
	<cfparam name="attributes.fieldLabels" type="struct" default="#structNew()#" />
	<cfparam name="attributes.config" type="struct" default="#structNew()#" />

<!--- make sure we have either a struct or an array of errors --->
<cfif NOT isArray(attributes.errors) AND NOT isStruct(attributes.errors)>
	<cfthrow errorcode="tags.forms.cfUniForm.form.invalidErrorPlacement" 
			message="The 'errors' attribute *must* be either an array or a struct." />
</cfif>

<cfif listFindNoCase("top,inline,both,none", attributes.errorMessagePlacement) EQ 0>
	<cfthrow errorcode="tags.forms.cfUniForm.form.invalidErrorPlacement" 
			message="Only the following are valid values for the 'errorMessagePlacement' argument: top,inline,both,none." />
</cfif>

<cfscript>
	err = attributes.errors;
	listType = lCase(attributes.errorListType);
	if ( NOT listFind("ul,ol", listType) ) { listType = "ul"; }
	jsConfig = "";
	_js = "";
	_jQ = "";
	_stdCSS = "";
	_stdJS = "";
	_validJS = "";
	_dateCSS = "";
	_dateJS = "";
	_timeCSS = "";
	_timeJS = "";
	_maskJS = "";
	_textareaJS = "";
	// merge the default _config with the attributes.config struct
	structAppend(_config, attributes.config, true);
</cfscript>

<cfsavecontent variable="jsConfig">
$("button[name='cancel']").click(function() { var input = $(':input'); input.each(function(i) { $(this).rules('remove'); }); $(':input').removeClass('required').addClass('ignore'); $('#<cfoutput>#attributes.id#</cfoutput>').validate({ignore: '.ignore'});<cfif len(attributes.cancelAction) GT 0>window.location.href='<cfoutput>#attributes.cancelAction#</cfoutput>'; return false;</cfif> });
</cfsavecontent>
<!--- // this will disable buttons after submit, but need to play with the validation plugin so that it only happens after successful validation
$("button.submitButton").click(function() { $(this).attr("disabled",true).html("Processing, please wait..."); $("button").attr("disabled",true); });
 --->
</cfsilent>
<cfsetting enablecfoutputonly="yes" />
<!--- BEGIN: executionMode check --->
<cfif thisTag.executionMode IS "end">
	
	<!--- make sure we have a fieldsets array --->
	<cfparam name="thisTag.fieldsets" default="#arrayNew(1)#" />
	
	<cfscript>
		_enctype = "application/x-www-form-urlencoded";
		
		for ( i=1; i LTE arrayLen(thisTag.fieldsets); i=i+1 ) {
			if ( thisTag.fieldsets[i].hasUpload ) {
				_enctype = "multipart/form-data";
				break;
			}
		}
	</cfscript>
	
	<!--- the tag execution is beginning, so open the form and display any validation error messages that exist --->
	<cfoutput><form action="#attributes.action#" method="#attributes.method#" enctype="#_enctype#" id="#attributes.id#" class="uniForm"></cfoutput>
	<!--- BEGIN: validation error check --->
	<cfif ((isStruct(err) AND structCount(err) GT 0) OR (isArray(err) AND arrayLen(err) GT 0))
			AND 
				(listFindNoCase("top,both", attributes.errorMessagePlacement) GT 0)>
		<cfoutput>
		<div id="errorMsg">
			<h3>#attributes.errorTitle#</h3>
			<p>#attributes.errorMessage#</p></cfoutput>
			<cfmodule template="#_config.renderer#" errors="#err#" listType="#listType#" />
		<cfoutput>
		</div>
		</cfoutput>
	</cfif>
	<!--- END: validation error check --->
	
	<!--- add okMsg --->
	<cfif len(attributes.okMsg) GT 0>
		<cfoutput><div id="OKMsg"><p>#attributes.okMsg#</p></div></cfoutput>
	</cfif>
		
		<cfloop from="1" to="#arrayLen(thisTag.fieldsets)#" index="i">
			<cfoutput>#thisTag.fieldsets[i].fullContent#</cfoutput>
		</cfloop>
		
		<!--- BEGIN: build the prerequisite JavaScript/CSS --->
		<!--- BEGIN: loadjQuery check --->
		<cfif attributes.loadjQuery>
			<cfsavecontent variable="_jQ">
				<cfoutput>
				<script src="#_config.jQuery#" type="text/javascript"></script></cfoutput>
			</cfsavecontent>
		</cfif>
		<!--- END: loadjQuery check --->
		
		<!--- standard CSS items for all Uni-Form markup forms --->
		<cfsavecontent variable="_stdCSS">
			<cfoutput><link href="#_config.uniformCSS#" type="text/css" rel="stylesheet" media="all" /><!--[if lte ie 7]><link href="#_config.uniformCSSie#" type="text/css" rel="stylesheet" media="all" /><![endif]--></cfoutput>
		</cfsavecontent>
		<!--- standard JS items for all Uni-Form markup forms --->
		<cfsavecontent variable="_stdJS">
			<cfoutput>
			<script src="#_config.uniformJS#" type="text/javascript"></script></cfoutput>
		</cfsavecontent>
		
		<!--- BEGIN: loadValidation check --->
		<cfif attributes.loadValidation>
			<!--- validation JS requirements --->
			<cfsavecontent variable="_validJS">
				<cfscript>
					_validationSetup = "";
					if ( len(trim(attributes.validationSetup)) GT 0 ) {
						_validationSetup = attributes.validationSetup;
					} else if ( (structKeyExists(_config, "validationSetup")) 
									AND 
										(isStruct(_config.validationSetup)) 
									AND 
										(structCount(_config.validationSetup) GT 0) ) {
						// loop through the struct and build the setup
						for ( key IN _config.validationSetup ) {
							if ( len(_validationSetup) GT 0 ) {
								_validationSetup = _validationSetup & ", ";
							}
							_validationSetup = _validationSetup & key & ": " & _config.validationSetup[key];
						}
						_validationSetup = "{" & _validationSetup & "}";
					}
				</cfscript>
				<cfset jsConfig = jsConfig & " $('###attributes.id#').validate(" & _validationSetup & ");" />
				<cfoutput>
				<script src="#_config.validationJS#" type="text/javascript"></script></cfoutput>
			</cfsavecontent>
		</cfif>
		<!--- END: loadValidation check --->
		
		<!--- BEGIN: loadDateUI check --->
		<cfif attributes.loadDateUI>
			<!--- dateUI CSS requirements --->
			<cfsavecontent variable="_dateCSS">
				<cfoutput>
				<link href="#_config.dateCSS#" rel="stylesheet" type="text/css" /></cfoutput>
			</cfsavecontent>
			
			<!--- dateUI JS requirements --->
			<cfsavecontent variable="_dateJS">
				<cfscript>
					_dateSetup = "";
					if ( len(trim(attributes.dateSetup)) GT 0 ) {
						_dateSetup = attributes.dateSetup;
					} else if ( (structKeyExists(_config, "dateSetup")) 
									AND 
										(isStruct(_config.dateSetup)) 
									AND 
										(structCount(_config.dateSetup) GT 0) ) {
						// loop through the struct and build the setup
						for ( key IN _config.dateSetup ) {
							if ( len(_dateSetup) GT 0 ) {
								_dateSetup = _dateSetup & ", ";
							}
							_dateSetup = _dateSetup & key & ": " & _config.dateSetup[key];
						}
						_dateSetup = "{" & _dateSetup & "}";
					}
				</cfscript>
				<cfoutput>
				<script src="#_config.dateJS#" type="text/javascript"></script></cfoutput>
				<!--- add any dateSetups to the jsConfig JavaScript --->
				<cfscript>
					// setup any generic datepicker stuff with the global setups
					jsConfig = jsConfig & " $('.addDatePicker').datepicker(" & _dateSetup & ");";
					for (f=1; f LTE arrayLen(thisTag.fieldsets); f=f+1) {
						dateGroup = thisTag.fieldsets[f].dateSetups;
						keys = structKeyArray(dateGroup);
						for (k=1; k LTE arrayLen(keys); k=k+1) {
							jsConfig = jsConfig & " $('##" & keys[k] & "').datepicker(" & dateGroup[keys[k]] & ");";
						}
					}
				</cfscript>
			</cfsavecontent>
		</cfif>
		<!--- END: loadDateUI check --->
		
		<!--- BEGIN: loadTimeUI check --->
		<cfif attributes.loadTimeUI>
			<!--- timeUI CSS requirements --->
			<cfsavecontent variable="_timeCSS">
				<cfoutput>
				<link href="#_config.timeCSS#" rel="stylesheet" type="text/css" /></cfoutput>
			</cfsavecontent>
			
			<!--- timeUI JS requirements --->
			<cfsavecontent variable="_timeJS">
				<cfscript>
					_timeSetup = "";
					if ( len(trim(attributes.timeSetup)) GT 0 ) {
						_timeSetup = attributes.timeSetup;
					} else if ( (structKeyExists(_config, "timeSetup")) 
									AND 
										(isStruct(_config.timeSetup)) 
									AND 
										(structCount(_config.timeSetup) GT 0) ) {
						// loop through the struct and build the setup
						for ( key IN _config.timeSetup ) {
							if ( len(_timeSetup) GT 0 ) {
								_timeSetup = _timeSetup & ", ";
							}
							_timeSetup = _timeSetup & key & ": " & _config.timeSetup[key];
						}
						_timeSetup = "{" & _timeSetup & "}";
					}
				</cfscript>
				<cfoutput>
				<script src="#_config.timeJS#" type="text/javascript"></script></cfoutput>
				<!--- add any timeSetups to the jsConfig JavaScript --->
				<cfscript>
					// setup any generic datepicker stuff with the global setups
					jsConfig = jsConfig & " $('.addTimePicker').timeEntry(" & _timeSetup & ");";
					for (f=1; f LTE arrayLen(thisTag.fieldsets); f=f+1) {
						timeGroup = thisTag.fieldsets[f].timeSetups;
						keys = structKeyArray(timeGroup);
						for (k=1; k LTE arrayLen(keys); k=k+1) {
							jsConfig = jsConfig & " $('##" & keys[k] & "').timeEntry(" & timeGroup[keys[k]] & ");";
						}
					}
				</cfscript>
			</cfsavecontent>
		</cfif>
		<!--- END: loadTimeUI check --->
		
		<!--- BEGIN: loadMaskUI check --->
		<cfif attributes.loadMaskUI>
			<cfsavecontent variable="_maskJS">
				<cfoutput>
				<script src="#_config.maskJS#" type="text/javascript"></script></cfoutput>
			</cfsavecontent>
			<!--- add any masks to the jsConfig JavaScript --->
			<cfscript>
				for (f=1; f LTE arrayLen(thisTag.fieldsets); f=f+1) {
					maskGroup = thisTag.fieldsets[f].masks;
					keys = structKeyArray(maskGroup);
					for (k=1; k LTE arrayLen(keys); k=k+1) {
						jsConfig = jsConfig & " $('##" & keys[k] & "').mask('" & maskGroup[keys[k]] & "');";
					}
				}
			</cfscript>
		</cfif>
		<!--- END: loadMaskUI check --->
		
		<!--- BEGIN: loadTextareaResize check --->
		<cfif attributes.loadTextareaResize>
			<!--- Textarea resize JS requirements --->
			<cfsavecontent variable="_textareaJS">
				<cfscript>
					_textareaSetup = "";
					if ( len(trim(attributes.textareaSetup)) GT 0 ) {
						_textareaSetup = attributes.textareaSetup;
					} else if ( (structKeyExists(_config, "textareaSetup")) 
									AND 
										(isStruct(_config.textareaSetup)) 
									AND 
										(structCount(_config.textareaSetup) GT 0) ) {
						// loop through the struct and build the setup
						for ( key IN _config.textareaSetup ) {
							if ( len(_textareaSetup) GT 0 ) {
								_textareaSetup = _textareaSetup & ", ";
							}
							_textareaSetup = _textareaSetup & key & ": " & _config.textareaSetup[key];
						}
						_textareaSetup = "{" & _textareaSetup & "}";
					}
					
					if ( len(_textareaSetup) EQ 0 ) {
						_textareaSetup = "{maxHeight: #attributes.textareaMaxHeight#}";
					} else if ( (find("maxHeight", _textareaSetup) EQ 0) 
									AND 
										(right(_textareaSetup, 1) IS "}") ) {
						_textareaSetup = left(_textareaSetup, len(_textareaSetup)-1) & ", maxHeight: #attributes.textareaMaxHeight#";
					}
				</cfscript>
				<cfset jsConfig = jsConfig & " $('.resizableTextarea').prettyComments(" & _textareaSetup & ");" />
				<cfoutput>
				<script src="#_config.textareaJS#" type="text/javascript"></script></cfoutput>
			</cfsavecontent>
		</cfif>
		<!--- END: loadTextareaResize check --->
		
		<cfscript>
			_CSS = _stdCSS & _dateCSS & _timeCSS;
			_JS = _jQ & _stdJS & _validJS & _dateJS & _timeJS & _maskJS & _textareaJS;
			_head = _CSS & _JS;
			if ( len(jsConfig) GT 0 ) {
				_head = _head & '<script type="text/javascript">$(document).ready(function() {' & jsConfig & ' });</script>';
			}
		</cfscript>
		<!--- END: build the prerequisite JavaScript/CSS --->
		
		<!--- insert the prereqs into the document head --->
		<cfhtmlhead text="#_head#" />
		
	<!--- BEGIN: showSubmit check --->
	<cfif attributes.showSubmit>
		<cfoutput><div class="buttonHolder"></cfoutput>
		<cfif attributes.showReset>
			<cfoutput><button type="reset" class="resetButton">#attributes.resetValue#</button>&nbsp;</cfoutput>
		</cfif>
		<cfif len(attributes.submit2Name) GT 0 AND len(attributes.submit2Value) GT 0 AND attributes.submit2placement IS "left">
			<cfoutput><button type="submit" class="submitButton float-left" name="#attributes.submit2name#">#attributes.submit2value#</button>&nbsp;</cfoutput>
		</cfif>
		<cfif len(attributes.submit2Name) GT 0 AND len(attributes.submit2Value) GT 0 AND attributes.submit2placement IS "before">
			<cfoutput><button type="submit" class="submitButton" name="#attributes.submit2name#">#attributes.submit2value#</button>&nbsp;</cfoutput>
		</cfif>
		
			<cfoutput><button type="submit" class="submitButton #attributes.submitButtonAddClass#">#attributes.submitValue#</button></cfoutput>
			
		<cfif len(attributes.submit2Name) GT 0 AND len(attributes.submit2Value) GT 0 AND attributes.submit2placement IS "after">
			<cfoutput>&nbsp;<button type="submit" class="submitButton" name="#attributes.submit2name#">#attributes.submit2value#</button></cfoutput>
		</cfif>
		<cfif attributes.showCancel>
			<cfoutput>&nbsp;<button class="submitButton" name="cancel">#attributes.cancelValue#</button></cfoutput>
		</cfif>
		<cfoutput></div></cfoutput>
	</cfif>
	<!--- END: showSubmit check --->
	
	<cfoutput></form></cfoutput>
</cfif>
<!--- END: executionMode check --->
<cfsetting enablecfoutputonly="no" />
