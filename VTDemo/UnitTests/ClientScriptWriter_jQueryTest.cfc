<!---
	// **************************************** LICENSE INFO **************************************** \\
	
	Copyright 2008, Bob Silverberg
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
--->
<cfcomponent extends="UnitTests.BaseTestCase" output="false">
	
	<cffunction name="setUp" access="public" returntype="void">
		<cfscript>
			ValidateThisConfig = getVTConfig();
			validationFactory = CreateObject("component","ValidateThis.core.ValidationFactory").init(ValidateThisConfig);
			ScriptWriter = validationFactory.getBean("ClientValidator").getScriptWriter("jQuery");
			createValStruct();
		</cfscript>
	</cffunction>
	
	<cffunction name="tearDown" access="public" returntype="void">
	</cffunction>

	<cffunction name="createValStruct" access="private" returntype="void">
		<cfscript>
			valStruct = StructNew();
			valStruct.ValType = "";
			valStruct.ClientFieldName = "FirstName";
			valStruct.PropertyName = "FirstName";
			valStruct.PropertyDesc = "First Name";
			valStruct.Parameters = StructNew(); 
			valStruct.Condition = StructNew(); 
			valStruct.formName = "frmMain"; 
		</cfscript>  
	</cffunction>

	
	<cffunction name="generateScriptHeaderShouldReturnCorrectScript" access="public" returntype="void">
		<cfscript>
			script = ScriptWriter.generateScriptHeader("formName");
			assertTrue(Trim(Script) CONTAINS "jQuery(document).ready(function($) {");
			assertTrue(Trim(Script) CONTAINS "$form_formName = $(""##formName"");");
			assertTrue(Trim(Script) CONTAINS "$form_formName.validate()");
		</cfscript>  
	</cffunction>

	<cffunction name="generateScriptHeaderShouldReturnSafeJSForUnsafeFormName" access="public" returntype="void">
		<cfscript>
			script = ScriptWriter.generateScriptHeader("form-Name2");
			assertTrue(Trim(Script) CONTAINS "jQuery(document).ready(function($) {");
			assertTrue(Trim(Script) CONTAINS "$form_formName2 = $(""##form-Name2"");");
			assertTrue(Trim(Script) CONTAINS "$form_formName2.validate()");
		</cfscript>  
	</cffunction>

	<cffunction name="generateScriptFooterShouldReturnCorrectScript" access="public" returntype="void">
		<cfscript>
			script = ScriptWriter.generateScriptFooter();
			assertEquals(Trim(Script),"});</script>");
		</cfscript>  
	</cffunction>

	<cffunction name="CustomValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			valStruct.ValType = "custom";
			script = ScriptWriter.generateValidationScript(valStruct,"frmMain");
			assertEquals("if ($form_frmmain.find("":input[name='firstname']"").length) { }",script);
			valStruct.Parameters = {remoteURL="aURL"}; 
			script = ScriptWriter.generateValidationScript(valStruct,"frmMain");
			assertEquals("if ($form_frmmain.find("":input[name='firstname']"").length) { $form_frmmain.find("":input[name='firstname']"").rules('add',{remote: 'aURL'});}",script);
		</cfscript>  
	</cffunction>

	<cffunction name="CustomValidationGeneratesCorrectScriptWithProblematicFormName" access="public" returntype="void">
		<cfscript>
			valStruct.ValType = "custom";
			script = ScriptWriter.generateValidationScript(valStruct,"frm-Main2");
			assertEquals("if ($form_frmMain2.find("":input[name='firstname']"").length) { }",script);
			valStruct.Parameters = {remoteURL="aURL"}; 
			script = ScriptWriter.generateValidationScript(valStruct,"frm-Main2");
			assertEquals("if ($form_frmMain2.find("":input[name='firstname']"").length) { $form_frmMain2.find("":input[name='firstname']"").rules('add',{remote: 'aURL'});}",script);
		</cfscript>  
	</cffunction>

	<cffunction name="DateValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			valStruct.ValType = "date";
			script = ScriptWriter.generateValidationScript(valStruct,"frmMain");
			assertEquals("if ($form_frmmain.find("":input[name='firstname']"").length) { $form_frmmain.find("":input[name='firstname']"").rules('add',{date: true});}",script);
		</cfscript>  
	</cffunction>

	<cffunction name="DateValidationGeneratesCorrectScriptWithProblematicFormName" access="public" returntype="void">
		<cfscript>
			valStruct.ValType = "date";
			script = ScriptWriter.generateValidationScript(valStruct,"frm-Main2");
			assertEquals("if ($form_frmMain2.find("":input[name='firstname']"").length) { $form_frmMain2.find("":input[name='firstname']"").rules('add',{date: true});}",script);
		</cfscript>  
	</cffunction>

	<cffunction name="EmailValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			valStruct.ValType = "email";
			script = ScriptWriter.generateValidationScript(valStruct,"frmMain");
			assertEquals("if ($form_frmmain.find("":input[name='firstname']"").length) { $form_frmmain.find("":input[name='firstname']"").rules('add',{email: true});}",Script);
		</cfscript>  
	</cffunction>

	<cffunction name="IntegerValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			valStruct.ValType = "integer";
			script = ScriptWriter.generateValidationScript(valStruct,"frmMain");
			assertEquals("if ($form_frmmain.find("":input[name='firstname']"").length) { $form_frmmain.find("":input[name='firstname']"").rules('add',{digits: true});}",script);
		</cfscript>  
	</cffunction>

	<cffunction name="NumericValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			valStruct.ValType = "numeric";
			script = ScriptWriter.generateValidationScript(valStruct,"frmMain");
			assertEquals("if ($form_frmmain.find("":input[name='firstname']"").length) { $form_frmmain.find("":input[name='firstname']"").rules('add',{number: true});}",script);
		</cfscript>  
	</cffunction>

	<cffunction name="RegexValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			valStruct.ValType = "regex";
			valStruct.Parameters = {Regex="^(Dr|Prof|Mr|Mrs|Ms|Miss)(\.)?$"}; 
			script = ScriptWriter.generateValidationScript(valStruct,"frmMain");
			assertTrue(Script CONTAINS "if ($form_frmmain.find("":input[name='firstname']"").length) { ");
			assertTrue(Script CONTAINS "$.validator.addMethod(""frmMainFirstNameregex"", $.validator.methods.regex, ""The First Name does not match the specified pattern."");");
			assertTrue(Script CONTAINS "$.validator.addClassRules(""frmMainFirstNameregex"", {frmMainFirstNameregex: /^(Dr|Prof|Mr|Mrs|Ms|Miss)(\.)?$/});");
			assertTrue(Script CONTAINS "$form_frmMain.find("":input[name='FirstName']"").addClass('frmMainFirstNameregex');");
		</cfscript>  
	</cffunction>
	
	<cffunction name="RegexValidationWithOverriddenPrefixGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			valStruct.ValType = "regex";
			valStruct.Parameters = {Regex="^(Dr|Prof|Mr|Mrs|Ms|Miss)(\.)?$"}; 
			ValidateThisConfig.defaultFailureMessagePrefix = "";
			validationFactory = CreateObject("component","ValidateThis.core.ValidationFactory").init(ValidateThisConfig);
			ScriptWriter = validationFactory.getBean("ClientValidator").getScriptWriter("jQuery");
			script = ScriptWriter.generateValidationScript(valStruct,"frmMain");
			assertTrue(Script CONTAINS "if ($form_frmmain.find("":input[name='firstname']"").length) { ");
			assertTrue(Script CONTAINS "$.validator.addMethod(""frmMainFirstNameregex"", $.validator.methods.regex, ""First Name does not match the specified pattern."");");
			assertTrue(Script CONTAINS "$.validator.addClassRules(""frmMainFirstNameregex"", {frmMainFirstNameregex: /^(Dr|Prof|Mr|Mrs|Ms|Miss)(\.)?$/});");
			assertTrue(Script CONTAINS "$form_frmMain.find("":input[name='FirstName']"").addClass('frmMainFirstNameregex');");
		</cfscript>  
	</cffunction>
	
	<cffunction name="SimpleRequiredValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			valStruct.ValType = "required";
			script = ScriptWriter.generateValidationScript(valStruct,"frmMain");
			assertEquals("if ($form_frmmain.find("":input[name='firstname']"").length) { $form_frmmain.find("":input[name='firstname']"").rules('add',{required: true});}",script);
		</cfscript>  
	</cffunction>

	<cffunction name="DependentPropertyRequiredValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			valStruct.ValType = "required";
			valStruct.Parameters = {DependentPropertyName="LastName"}; 
			script = ScriptWriter.generateValidationScript(valStruct,"frmMain");
			assertTrue(Script CONTAINS "if ($form_frmmain.find("":input[name='firstname']"").length) { ");
			assertTrue(Script CONTAINS "$.validator.addMethod(""frmMainFirstNamerequired"", $.validator.methods.required);");
			assertTrue(Script CONTAINS "$.validator.addClassRules(""frmMainFirstNamerequired"", {frmMainFirstNamerequired: function(element) { return $form_frmMain.find("":input[name='lastname']"").getvalue().length > 0; }});");
			assertTrue(Script CONTAINS "$form_frmMain.find("":input[name='FirstName']"").addClass('frmMainFirstNamerequired');");
		</cfscript>  
	</cffunction>
	
	<cffunction name="DependentPropertyRequiredValidationGeneratesCorrectScriptWithProblematicFormName" access="public" returntype="void">
		<cfscript>
			valStruct.ValType = "required";
			valStruct.Parameters = {DependentPropertyName="LastName"}; 
			script = ScriptWriter.generateValidationScript(valStruct,"frm-Main2");
			assertTrue(Script CONTAINS "if ($form_frmmain2.find("":input[name='firstname']"").length) { ");
			assertTrue(Script CONTAINS "$.validator.addMethod(""frmMain2FirstNamerequired"", $.validator.methods.required);");
			assertTrue(Script CONTAINS "$.validator.addClassRules(""frmMain2FirstNamerequired"", {frmMain2FirstNamerequired: function(element) { return $form_frmMain2.find("":input[name='lastname']"").getvalue().length > 0; }});");
			assertTrue(Script CONTAINS "$form_frmMain2.find("":input[name='FirstName']"").addClass('frmMain2FirstNamerequired');");
		</cfscript>  
	</cffunction>
	
	<cffunction name="DependentValueRequiredValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			valStruct.ValType = "required";
			valStruct.Parameters = {DependentPropertyName="LastName",DependentPropertyValue="Silverberg"}; 
			script = ScriptWriter.generateValidationScript(valStruct,"frmMain");
			//assertEquals(Script,"$form_frmmain.find("":input[name='firstname']"").rules('add',{required: true});");
			assertTrue(Script CONTAINS "if ($form_frmmain.find("":input[name='firstname']"").length) { ");
			assertTrue(Script CONTAINS "$.validator.addMethod(""frmMainFirstNamerequired"", $.validator.methods.required);");
			assertTrue(Script CONTAINS "$.validator.addClassRules(""frmMainFirstNamerequired"", {frmMainFirstNamerequired: function(element) { return $form_frmMain.find("":input[name='lastname']"").getvalue() == 'silverberg'; }});");
			assertTrue(Script CONTAINS "$form_frmMain.find("":input[name='FirstName']"").addClass('frmMainFirstNamerequired');");
		</cfscript>  
	</cffunction>

	<cffunction name="DependentValueRequiredValidationGeneratesCorrectScriptWithProblematicFormName" access="public" returntype="void">
		<cfscript>
			valStruct.ValType = "required";
			valStruct.Parameters = {DependentPropertyName="LastName",DependentPropertyValue="Silverberg"}; 
			script = ScriptWriter.generateValidationScript(valStruct,"frm-Main2");
			//assertEquals(Script,"$form_frmmain.find("":input[name='firstname']"").rules('add',{required: true});");
			assertTrue(Script CONTAINS "if ($form_frmmain2.find("":input[name='firstname']"").length) { ");
			assertTrue(Script CONTAINS "$.validator.addMethod(""frmMain2FirstNamerequired"", $.validator.methods.required);");
			assertTrue(Script CONTAINS "$.validator.addClassRules(""frmMain2FirstNamerequired"", {frmMain2FirstNamerequired: function(element) { return $form_frmMain2.find("":input[name='lastname']"").getvalue() == 'silverberg'; }});");
			assertTrue(Script CONTAINS "$form_frmMain2.find("":input[name='FirstName']"").addClass('frmMain2FirstNamerequired');");
		</cfscript>  
	</cffunction>

	<cffunction name="DependentFieldRequiredValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			valStruct.ValType = "required";
			valStruct.Parameters = {DependentPropertyName="LastName",DependentFieldName="User[LastName]"}; 
			script = ScriptWriter.generateValidationScript(valStruct,"frmMain");
			assertTrue(Script CONTAINS "if ($form_frmmain.find("":input[name='firstname']"").length) { ");
			assertTrue(Script CONTAINS "$.validator.addMethod(""frmMainFirstNamerequired"", $.validator.methods.required);");
			assertTrue(Script CONTAINS "$.validator.addClassRules(""frmMainFirstNamerequired"", {frmMainFirstNamerequired: function(element) { return $form_frmMain.find("":input[name='User[LastName]']"").getvalue().length > 0; }});");
			assertTrue(Script CONTAINS "$form_frmMain.find("":input[name='FirstName']"").addClass('frmMainFirstNamerequired');");
		</cfscript>  
	</cffunction>
	
	<cffunction name="DependentFieldRequiredValidationGeneratesCorrectScriptWithProblematicFormName" access="public" returntype="void">
		<cfscript>
			valStruct.ValType = "required";
			valStruct.Parameters = {DependentPropertyName="LastName",DependentFieldName="User[LastName]"}; 
			script = ScriptWriter.generateValidationScript(valStruct,"frm-Main2");
			assertTrue(Script CONTAINS "if ($form_frmmain2.find("":input[name='firstname']"").length) { ");
			assertTrue(Script CONTAINS "$.validator.addMethod(""frmMain2FirstNamerequired"", $.validator.methods.required);");
			assertTrue(Script CONTAINS "$.validator.addClassRules(""frmMain2FirstNamerequired"", {frmMain2FirstNamerequired: function(element) { return $form_frmMain2.find("":input[name='User[LastName]']"").getvalue().length > 0; }});");
			assertTrue(Script CONTAINS "$form_frmMain2.find("":input[name='FirstName']"").addClass('frmMain2FirstNamerequired');");
		</cfscript>  
	</cffunction>
	
	<cffunction name="MinLengthValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			theLength = 5;
			valStruct.ValType = "minlength";
			valStruct.Parameters.minlength = theLength;
			script = ScriptWriter.generateValidationScript(valStruct,"frmMain");
			assertEquals("if ($form_frmmain.find("":input[name='firstname']"").length) { $form_frmmain.find("":input[name='firstname']"").rules('add',{minlength: 5});}",script);
		</cfscript>  
	</cffunction>

	<cffunction name="MaxLengthValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			theLength = 5;
			valStruct.ValType = "maxlength";
			valStruct.Parameters.maxlength = theLength;
			script = ScriptWriter.generateValidationScript(valStruct,"frmMain");
			assertEquals("if ($form_frmmain.find("":input[name='firstname']"").length) { $form_frmmain.find("":input[name='firstname']"").rules('add',{maxlength: 5});}",script);
		</cfscript>  
	</cffunction>

	<cffunction name="RangeLengthValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			minLength = 5;
			maxLength = 10;
			valStruct.ValType = "rangelength";
			valStruct.Parameters.minlength = minLength;
			valStruct.Parameters.maxlength = maxLength;
			script = ScriptWriter.generateValidationScript(valStruct,"frmMain");
			assertEquals("if ($form_frmmain.find("":input[name='firstname']"").length) { $form_frmmain.find("":input[name='firstname']"").rules('add',{rangelength: [5,10]});}",script);
		</cfscript>  
	</cffunction>

	<cffunction name="MinValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			theVal = 5;
			valStruct.ValType = "min";
			valStruct.Parameters.min = theVal;
			script = ScriptWriter.generateValidationScript(valStruct,"frmMain");
			assertEquals("if ($form_frmmain.find("":input[name='firstname']"").length) { $form_frmmain.find("":input[name='firstname']"").rules('add',{min: 5});}",script);
		</cfscript>  
	</cffunction>

	<cffunction name="MaxValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			theVal = 5;
			valStruct.ValType = "max";
			valStruct.Parameters.max = theVal;
			script = ScriptWriter.generateValidationScript(valStruct,"frmMain");
			assertEquals("if ($form_frmmain.find("":input[name='firstname']"").length) { $form_frmmain.find("":input[name='firstname']"").rules('add',{max: 5});}",script);
		</cfscript>  
	</cffunction>

	<cffunction name="RangeValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			min = 5;
			max = 10;
			valStruct.ValType = "range";
			valStruct.Parameters.min = min;
			valStruct.Parameters.max = max;
			script = ScriptWriter.generateValidationScript(valStruct,"frmMain");
			assertEquals("if ($form_frmmain.find("":input[name='firstname']"").length) { $form_frmmain.find("":input[name='firstname']"").rules('add',{range: [5,10]});}",script);
		</cfscript>  
	</cffunction>

	<cffunction name="EqualToValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			ComparePropertyName = "LastName";
			ComparePropertyDesc = "Last Name";
			valStruct.ValType = "EqualTo";
			valStruct.Parameters.ComparePropertyName = ComparePropertyName;
			valStruct.Parameters.ComparePropertyDesc = ComparePropertyDesc;
			script = ScriptWriter.generateValidationScript(valStruct,"frmMain");
			assertTrue(Script CONTAINS "if ($form_frmmain.find("":input[name='firstname']"").length) { ");
			assertTrue(Script CONTAINS "$.validator.addMethod(""frmMainFirstNameEqualTo"", $.validator.methods.EqualTo, ""The First Name must be the same as the Last Name."");");
			assertTrue(Script CONTAINS "$.validator.addClassRules(""frmMainFirstNameEqualTo"", {frmMainFirstNameEqualTo: '##frmMain :input[name=""LastName""]'});");
			assertTrue(Script CONTAINS "$form_frmMain.find("":input[name='FirstName']"").addClass('frmMainFirstNameEqualTo');");
		</cfscript>
	</cffunction>

	<cffunction name="EqualToValidationGeneratesCorrectScriptWithProblematicFormName" access="public" returntype="void">
		<cfscript>
			ComparePropertyName = "LastName";
			ComparePropertyDesc = "Last Name";
			valStruct.ValType = "EqualTo";
			valStruct.Parameters.ComparePropertyName = ComparePropertyName;
			valStruct.Parameters.ComparePropertyDesc = ComparePropertyDesc;
			script = ScriptWriter.generateValidationScript(valStruct,"frm-Main2");
			assertTrue(Script CONTAINS "if ($form_frmmain2.find("":input[name='firstname']"").length) { ");
			assertTrue(Script CONTAINS "$.validator.addMethod(""frmMain2FirstNameEqualTo"", $.validator.methods.EqualTo, ""The First Name must be the same as the Last Name."");");
			assertTrue(Script CONTAINS "$.validator.addClassRules(""frmMain2FirstNameEqualTo"", {frmMain2FirstNameEqualTo: '##frm-Main2 :input[name=""LastName""]'});");
			assertTrue(Script CONTAINS "$form_frmMain2.find("":input[name='FirstName']"").addClass('frmMain2FirstNameEqualTo');");
		</cfscript>
	</cffunction>

	<cffunction name="EqualToValidationGeneratesCorrectScriptWithOverriddenPrefix" access="public" returntype="void">
		<cfscript>
			ComparePropertyName = "LastName";
			ComparePropertyDesc = "Last Name";
			valStruct.ValType = "EqualTo";
			valStruct.Parameters.ComparePropertyName = ComparePropertyName;
			valStruct.Parameters.ComparePropertyDesc = ComparePropertyDesc;
			ValidateThisConfig.defaultFailureMessagePrefix = "";
			validationFactory = CreateObject("component","ValidateThis.core.ValidationFactory").init(ValidateThisConfig);
			ScriptWriter = validationFactory.getBean("ClientValidator").getScriptWriter("jQuery");
			script = ScriptWriter.generateValidationScript(valStruct,"frm-Main2");
			assertTrue(Script CONTAINS "if ($form_frmmain2.find("":input[name='firstname']"").length) { ");
			assertTrue(Script CONTAINS "$.validator.addMethod(""frmMain2FirstNameEqualTo"", $.validator.methods.EqualTo, ""First Name must be the same as the Last Name."");");
			assertTrue(Script CONTAINS "$.validator.addClassRules(""frmMain2FirstNameEqualTo"", {frmMain2FirstNameEqualTo: '##frm-Main2 :input[name=""LastName""]'});");
			assertTrue(Script CONTAINS "$form_frmMain2.find("":input[name='FirstName']"").addClass('frmMain2FirstNameEqualTo');");
		</cfscript>
	</cffunction>

	<cffunction name="BooleanValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			valStruct.ValType = "boolean";
			script = ScriptWriter.generateValidationScript(valStruct,"frmMain");
			assertEquals("if ($form_frmmain.find("":input[name='firstname']"").length) { $form_frmmain.find("":input[name='firstname']"").rules('add',{boolean: true});}",Script);
			
		</cfscript>  
	</cffunction>

</cfcomponent>

