<!---
	
filename:		\VTDemo\UnitTests\ClientScriptWriter_jQueryTest.cfc
date created:	2008-10-22
author:			Bob Silverberg (http://www.silverwareconsulting.com/)
purpose:		I ClientScriptWriter_jQueryTest.cfc
				
	// **************************************** LICENSE INFO **************************************** \\
	
	Copyright 2008, Bob Silverberg
	
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
	2008-10-22	New																		BS

--->
<cfcomponent displayname="UnitTests.ClientScriptWriter_jQueryTest" extends="UnitTests.BaseTestCase" output="false">
	
	<cfset ScriptWriter = "" />
	
	<cffunction name="setUp" access="public" returntype="void">
		<cfscript>
			ValidateThisConfig = getVTConfig();
			validationFactory = CreateObject("component","ValidateThis.core.ValidationFactory").init(ValidateThisConfig);
			ScriptWriter = validationFactory.getBean("ClientValidator").getScriptWriter("jQuery");
		</cfscript>
	</cffunction>
	
	<cffunction name="tearDown" access="public" returntype="void">
	</cffunction>

	<cffunction name="myTest" access="public" returntype="void">
		<cfscript>
		</cfscript>  
	</cffunction>

	
	<cffunction name="generateScriptHeaderShouldReturnCorrectScript" access="public" returntype="void">
		<cfscript>
			script = ScriptWriter.generateScriptHeader("");
			assertTrue(Trim(Script) CONTAINS "$(document).ready(function() {");
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
			valStruct = StructNew();
			valStruct.ValType = "custom";
			valStruct.ClientFieldName = "FirstName";
			valStruct.PropertyName = "FirstName";
			valStruct.PropertyDesc = "First Name";
			valStruct.Parameters = StructNew(); 
			valStruct.Condition = StructNew(); 
			script = ScriptWriter.generateValidationScript(valStruct);
			assertEquals("if ($(""##firstname"").length) { }",script);
			valStruct.Parameters = {remoteURL="aURL"}; 
			valStruct.Condition = StructNew(); 
			script = ScriptWriter.generateValidationScript(valStruct);
			assertEquals("if ($(""##firstname"").length) { $(""##FirstName"").rules('add',{remote: 'aURL'});}",script);
		</cfscript>  
	</cffunction>

	<cffunction name="DateValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			valStruct = StructNew();
			valStruct.ValType = "date";
			valStruct.ClientFieldName = "FirstName";
			valStruct.PropertyDesc = "First Name";
			valStruct.Parameters = StructNew(); 
			valStruct.Condition = StructNew(); 
			script = ScriptWriter.generateValidationScript(valStruct);
			assertEquals("if ($(""##firstname"").length) { $(""##firstname"").rules('add',{date: true});}",script);
		</cfscript>  
	</cffunction>

	<cffunction name="EmailValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			valStruct = StructNew();
			valStruct.ValType = "email";
			valStruct.ClientFieldName = "FirstName";
			valStruct.PropertyDesc = "First Name";
			valStruct.Parameters = StructNew(); 
			valStruct.Condition = StructNew(); 
			script = ScriptWriter.generateValidationScript(valStruct);
			assertEquals("if ($(""##firstname"").length) { $(""##firstname"").rules('add',{email: true});}",Script);
		</cfscript>  
	</cffunction>

	<cffunction name="IntegerValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			valStruct = StructNew();
			valStruct.ValType = "integer";
			valStruct.ClientFieldName = "FirstName";
			valStruct.PropertyDesc = "First Name";
			valStruct.Parameters = StructNew(); 
			valStruct.Condition = StructNew(); 
			script = ScriptWriter.generateValidationScript(valStruct);
			assertEquals("if ($(""##firstname"").length) { $(""##FirstName"").rules('add',{digits: true});}",script);
		</cfscript>  
	</cffunction>

	<cffunction name="NumericValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			valStruct = StructNew();
			valStruct.ValType = "numeric";
			valStruct.ClientFieldName = "FirstName";
			valStruct.PropertyDesc = "First Name";
			valStruct.Parameters = StructNew(); 
			valStruct.Condition = StructNew(); 
			script = ScriptWriter.generateValidationScript(valStruct);
			assertEquals("if ($(""##firstname"").length) { $(""##FirstName"").rules('add',{number: true});}",script);
		</cfscript>  
	</cffunction>

	<cffunction name="SimpleRequiredValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			valStruct = StructNew();
			valStruct.ValType = "required";
			valStruct.ClientFieldName = "FirstName";
			valStruct.PropertyDesc = "First Name";
			valStruct.Parameters = StructNew(); 
			valStruct.Condition = StructNew();
			script = ScriptWriter.generateValidationScript(valStruct);
			assertEquals("if ($(""##firstname"").length) { $(""##FirstName"").rules('add',{required: true});}",script);
		</cfscript>  
	</cffunction>

	<cffunction name="DependentPropertyRequiredValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			valStruct = StructNew();
			valStruct.ValType = "required";
			valStruct.ClientFieldName = "FirstName";
			valStruct.PropertyDesc = "First Name";
			valStruct.Parameters = {DependentPropertyName="LastName"}; 
			valStruct.Condition = StructNew();
			script = ScriptWriter.generateValidationScript(valStruct);
			assertTrue(Script CONTAINS "if ($(""##firstname"").length) { ");
			assertTrue(Script CONTAINS "$.validator.addmethod(""firstnamerequired"", $.validator.methods.required);");
			assertTrue(Script CONTAINS "$.validator.addclassrules(""firstnamerequired"", {firstnamerequired: function(element) { return $(""[name='lastname']"").getvalue().length > 0; }});");
			assertTrue(Script CONTAINS "$(""##firstname"").addclass('firstnamerequired');");
		</cfscript>  
	</cffunction>
	
	<cffunction name="DependentValueRequiredValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			valStruct = StructNew();
			valStruct.ValType = "required";
			valStruct.ClientFieldName = "FirstName";
			valStruct.PropertyDesc = "First Name";
			valStruct.Parameters = {DependentPropertyName="LastName",DependentPropertyValue="Silverberg"}; 
			valStruct.Condition = StructNew();
			script = ScriptWriter.generateValidationScript(valStruct);
			//assertEquals(Script,"$(""##FirstName"").rules('add',{required: true});");
			assertTrue(Script CONTAINS "if ($(""##firstname"").length) { ");
			assertTrue(Script CONTAINS "$.validator.addmethod(""firstnamerequired"", $.validator.methods.required);");
			assertTrue(Script CONTAINS "$.validator.addclassrules(""firstnamerequired"", {firstnamerequired: function(element) { return $(""[name='lastname']"").getvalue() == 'silverberg'; }});");
			assertTrue(Script CONTAINS "$(""##firstname"").addclass('firstnamerequired');");
		</cfscript>  
	</cffunction>

	<cffunction name="DependentFieldRequiredValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			valStruct = StructNew();
			valStruct.ValType = "required";
			valStruct.ClientFieldName = "FirstName";
			valStruct.PropertyDesc = "First Name";
			valStruct.Parameters = {DependentPropertyName="LastName",DependentFieldName="User[LastName]"}; 
			valStruct.Condition = StructNew();
			script = ScriptWriter.generateValidationScript(valStruct);
			assertTrue(Script CONTAINS "if ($(""##firstname"").length) { ");
			assertTrue(Script CONTAINS "$.validator.addmethod(""firstnamerequired"", $.validator.methods.required);");
			assertTrue(Script CONTAINS "$.validator.addclassrules(""firstnamerequired"", {firstnamerequired: function(element) { return $(""[name='User[LastName]']"").getvalue().length > 0; }});");
			assertTrue(Script CONTAINS "$(""##firstname"").addclass('firstnamerequired');");
		</cfscript>  
	</cffunction>
	
	<cffunction name="MinLengthValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			theLength = 5;
			valStruct = StructNew();
			valStruct.ValType = "minlength";
			valStruct.ClientFieldName = "FirstName";
			valStruct.PropertyDesc = "First Name";
			valStruct.Parameters = StructNew();
			valStruct.Parameters.minlength = theLength;
			valStruct.Condition = StructNew(); 
			script = ScriptWriter.generateValidationScript(valStruct);
			assertEquals("if ($(""##firstname"").length) { $(""##FirstName"").rules('add',{minlength: 5});}",script);
		</cfscript>  
	</cffunction>

	<cffunction name="MaxLengthValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			theLength = 5;
			valStruct = StructNew();
			valStruct.ValType = "maxlength";
			valStruct.ClientFieldName = "FirstName";
			valStruct.PropertyDesc = "First Name";
			valStruct.Parameters = StructNew();
			valStruct.Parameters.maxlength = theLength;
			valStruct.Condition = StructNew(); 
			script = ScriptWriter.generateValidationScript(valStruct);
			assertEquals("if ($(""##firstname"").length) { $(""##FirstName"").rules('add',{maxlength: 5});}",script);
		</cfscript>  
	</cffunction>

	<cffunction name="RangeLengthValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			minLength = 5;
			maxLength = 10;
			valStruct = StructNew();
			valStruct.ValType = "rangelength";
			valStruct.ClientFieldName = "FirstName";
			valStruct.PropertyDesc = "First Name";
			valStruct.Parameters = StructNew();
			valStruct.Parameters.minlength = minLength;
			valStruct.Parameters.maxlength = maxLength;
			valStruct.Condition = StructNew(); 
			script = ScriptWriter.generateValidationScript(valStruct);
			assertEquals("if ($(""##firstname"").length) { $(""##FirstName"").rules('add',{rangelength: [5,10]});}",script);
		</cfscript>  
	</cffunction>

	<cffunction name="MinValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			theVal = 5;
			valStruct = StructNew();
			valStruct.ValType = "min";
			valStruct.ClientFieldName = "FirstName";
			valStruct.PropertyDesc = "First Name";
			valStruct.Parameters = StructNew();
			valStruct.Parameters.min = theVal;
			valStruct.Condition = StructNew(); 
			script = ScriptWriter.generateValidationScript(valStruct);
			assertEquals("if ($(""##firstname"").length) { $(""##FirstName"").rules('add',{min: 5});}",script);
		</cfscript>  
	</cffunction>

	<cffunction name="MaxValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			theVal = 5;
			valStruct = StructNew();
			valStruct.ValType = "max";
			valStruct.ClientFieldName = "FirstName";
			valStruct.PropertyDesc = "First Name";
			valStruct.Parameters = StructNew();
			valStruct.Parameters.max = theVal;
			valStruct.Condition = StructNew(); 
			script = ScriptWriter.generateValidationScript(valStruct);
			assertEquals("if ($(""##firstname"").length) { $(""##firstname"").rules('add',{max: 5});}",script);
		</cfscript>  
	</cffunction>

	<cffunction name="RangeValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			min = 5;
			max = 10;
			valStruct = StructNew();
			valStruct.ValType = "range";
			valStruct.ClientFieldName = "FirstName";
			valStruct.PropertyDesc = "First Name";
			valStruct.Parameters = StructNew();
			valStruct.Parameters.min = min;
			valStruct.Parameters.max = max;
			valStruct.Condition = StructNew(); 
			script = ScriptWriter.generateValidationScript(valStruct);
			assertEquals("if ($(""##firstname"").length) { $(""##FirstName"").rules('add',{range: [5,10]});}",script);
		</cfscript>  
	</cffunction>

	<cffunction name="EqualToValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			ComparePropertyName = "LastName";
			ComparePropertyDesc = "Last Name";
			valStruct = StructNew();
			valStruct.ValType = "EqualTo";
			valStruct.ClientFieldName = "FirstName";
			valStruct.PropertyDesc = "First Name";
			valStruct.Parameters = StructNew();
			valStruct.Parameters.ComparePropertyName = ComparePropertyName;
			valStruct.Parameters.ComparePropertyDesc = ComparePropertyDesc;
			valStruct.Condition = StructNew(); 
			script = ScriptWriter.generateValidationScript(valStruct);
			assertTrue(Script CONTAINS "if ($(""##firstname"").length) { ");
			assertTrue(Script CONTAINS "$.validator.addMethod(""FirstNameEqualTo"", $.validator.methods.EqualTo, ""The First Name must be the same as the Last Name."");");
			assertTrue(Script CONTAINS "$.validator.addClassRules(""FirstNameEqualTo"", {FirstNameEqualTo: '##LastName'});");
			assertTrue(Script CONTAINS "$(""##FirstName"").addClass('FirstNameEqualTo');");
		</cfscript>
	</cffunction>

	<cffunction name="BooleanValidationGeneratesCorrectScript" access="public" returntype="void">
		<cfscript>
			valStruct = StructNew();
			valStruct.ValType = "boolean";
			valStruct.ClientFieldName = "FirstName";
			valStruct.PropertyDesc = "First Name";
			valStruct.Parameters = StructNew(); 
			valStruct.Condition = StructNew(); 
			script = ScriptWriter.generateValidationScript(valStruct);
			assertEquals("if ($(""##firstname"").length) { $(""##firstname"").rules('add',{boolean: true});}",Script);
		</cfscript>  
	</cffunction>

</cfcomponent>

