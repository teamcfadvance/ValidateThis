<!---
	// **************************************** LICENSE INFO **************************************** \\
	
	Copyright 2010, Bob Silverberg
	
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
			VTConfig = getVTConfig();
			VTConfig.extraClientScriptWriterComponentPaths="VTDemo.UnitTests.Fixture.BigNumberTest.CRSs";
			VTConfig.extraRuleValidatorComponentPaths="VTDemo.UnitTests.Fixture.BigNumberTest.SRVs";
			VTConfig.definitionPath = getDirectoryFromPath(getCurrentTemplatePath()) & "Fixture/BigNumberTest";
			ValidateThis = CreateObject("component","ValidateThis.ValidateThis").init(VTConfig);
		</cfscript>
	</cffunction>
	
	<cffunction name="tearDown" access="public" returntype="void">
	</cffunction>

	<cffunction name="additionalRuleShouldBeAvailableToClientSideValidations" access="public" returntype="void">
		<cfscript>
			script = ValidateThis.getValidationScript(objectType="BigNumber");
			assertEquals(true,script CONTAINS "rules('add',{min: 1000});");
		</cfscript>  
	</cffunction>

	<cffunction name="additionalRuleShouldBeAvailableToServerSideValidations" access="public" returntype="void">
		<cfscript>
			bigNumber = createObject("component","VTDemo.UnitTests.Fixture.BigNumberTest.BigNumber").init();
			result = ValidateThis.validate(bigNumber);
			assertEquals(false,result.getIsSuccess());
			failures = result.getFailures();
			assertEquals(1,arrayLen(failures));
			assertEquals("bigNumber",failures[1].type);
			assertEquals("The User Id must be a number greater than 999.",failures[1].message);
			bigNumber.setUserId(999);
			result = ValidateThis.validate(bigNumber);
			assertEquals(false,result.getIsSuccess());
			bigNumber.setUserId(1000);
			result = ValidateThis.validate(bigNumber);
			assertEquals(true,result.getIsSuccess());
		</cfscript>  
	</cffunction>

</cfcomponent>

