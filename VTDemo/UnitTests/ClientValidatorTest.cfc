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
	
	<cfset ClientValidator = "" />
	
	<cffunction name="setUp" access="public" returntype="void">
		<cfscript>
			ValidateThisConfig = getVTConfig();
			validation = {clientFieldName="clientFieldName",condition=structNew(),formName="formName",parameters=structNew(),propertyDesc="propertyDesc",propertyName="propertyName",valType="required"};
			validations = [validation];
		</cfscript>
	</cffunction>
	
	<cffunction name="tearDown" access="public" returntype="void">
	</cffunction>

	<cffunction name="ClientScriptWritersShouldBeLoadedCorrectly" access="public" returntype="void">
		<cfscript>
			validationFactory = CreateObject("component","ValidateThis.core.ValidationFactory").init(ValidateThisConfig);
			ClientValidator = validationFactory.getBean("ClientValidator");
			ClientScriptWriters = ClientValidator.getScriptWriters();
			assertTrue(IsStruct(ClientScriptWriters));
			assertTrue(GetMetadata(ClientScriptWriters.jQuery).name CONTAINS "ClientScriptWriter_jQuery");
			assertTrue(StructKeyExists(ClientScriptWriters.jQuery,"generateValidationScript"));
		</cfscript>  
	</cffunction>

	<cffunction name="ExtraClientScriptWriterShouldBeLoaded" access="public" returntype="void">
		<cfscript>
			ValidateThisConfig.extraClientScriptWriterComponentPaths="VTDemo.UnitTests.Fixture.ClientScriptWriters.newCSW";
			validationFactory = CreateObject("component","ValidateThis.core.ValidationFactory").init(ValidateThisConfig);
			ClientValidator = validationFactory.getBean("ClientValidator");
			ClientScriptWriters = ClientValidator.getScriptWriters();
			assertTrue(IsStruct(ClientScriptWriters));
			assertTrue(GetMetadata(ClientScriptWriters.newCSW).name CONTAINS "ClientScriptWriter_newCSW");
			assertTrue(StructKeyExists(ClientScriptWriters.newCSW,"generateValidationScript"));
		</cfscript>  
	</cffunction>

	<cffunction name="OverrideClientScriptWritersShouldBeLoaded" access="public" returntype="void">
		<cfscript>
			ValidateThisConfig.extraClientScriptWriterComponentPaths="VTDemo.UnitTests.Fixture.ClientScriptWriters.newCSW,VTDemo.UnitTests.Fixture.ClientScriptWriters.jQuery";
			validationFactory = CreateObject("component","ValidateThis.core.ValidationFactory").init(ValidateThisConfig);
			ClientValidator = validationFactory.getBean("ClientValidator");
			ClientScriptWriters = ClientValidator.getScriptWriters();
			assertTrue(IsStruct(ClientScriptWriters));
			assertTrue(GetMetadata(ClientScriptWriters.jQuery).name CONTAINS "Fixture");
			assertTrue(StructKeyExists(ClientScriptWriters.jQuery,"generateValidationScript"));
			assertTrue(GetMetadata(ClientScriptWriters.newCSW).name CONTAINS "ClientScriptWriter_newCSW");
			assertTrue(StructKeyExists(ClientScriptWriters.newCSW,"generateValidationScript"));
		</cfscript>  
	</cffunction>

	<cffunction name="getValidationScriptShouldHonourPassedInFormName" access="public" returntype="void">
		<cfscript>
			validationFactory = CreateObject("component","ValidateThis.core.ValidationFactory").init(ValidateThisConfig);
			ClientValidator = validationFactory.getBean("ClientValidator");
			script = ClientValidator.getValidationScript(validations=validations,formName="testFormName",jsLib="jQuery");
			debug(script);
			assertTrue(script contains "$form_testFormName = $(""##testFormName"");");
			assertTrue(script contains "$form_testFormName.validate();");
			assertTrue(script contains "if ($form_testFormName.find("":input[name='clientFieldName']"").length)");
			assertTrue(script contains "$form_testFormName.find("":input[name='clientFieldName']"").rules");
		</cfscript>  
	</cffunction>

</cfcomponent>

