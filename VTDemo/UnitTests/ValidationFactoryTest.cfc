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
		</cfscript>
	</cffunction>
	
	<cffunction name="loadChildObjectsShouldReturnCollectionOfBuiltInServerRuleValidators" access="public" returntype="void">
		<cfscript>
			initargs={objectChecker=mock()};
			SRVs = validationFactory.loadChildObjects("ValidateThis.server","ServerRuleValidator_",StructNew(),initargs);
			assertEquals(true,structKeyExists(SRVs,"Boolean"));
			assertEquals("ValidateThis.server.serverrulevalidator_boolean",GetMetadata(SRVs.Boolean).name);
			assertTrue(StructKeyExists(SRVs.Boolean,"validate"));
		</cfscript>
	</cffunction>

	<cffunction name="loadChildObjectsShouldReturnCollectionOfServerRuleValidatorsFromTwoPaths" access="public" returntype="void">
		<cfscript>
			initargs={objectChecker=mock()};
			SRVs = validationFactory.loadChildObjects("ValidateThis.server,VTDemo.UnitTests.Fixture.ServerRuleValidators","ServerRuleValidator_",StructNew(),initargs);
			assertEquals(true,structKeyExists(SRVs,"Boolean"));
			assertEquals("ValidateThis.server.serverrulevalidator_boolean",GetMetadata(SRVs.Boolean).name);
			assertTrue(StructKeyExists(SRVs.Boolean,"validate"));
			assertEquals(true,structKeyExists(SRVs,"Extra"));
			assertEquals("vtdemo.unittests.fixture.serverrulevalidators.serverrulevalidator_extra",GetMetadata(SRVs.Extra).name);
			assertTrue(StructKeyExists(SRVs.Extra,"validate"));
		</cfscript>
	</cffunction>

	<cffunction name="loadChildObjectsShouldReturnCollectionOfServerRuleValidatorsWithOverrides" access="public" returntype="void">
		<cfscript>
			initargs={objectChecker=mock()};
			SRVs = validationFactory.loadChildObjects("ValidateThis.server,VTDemo.UnitTests.Fixture.OverrideServerRuleValidators","ServerRuleValidator_",StructNew(),initargs);
			assertEquals(true,structKeyExists(SRVs,"Boolean"));
			assertEquals("ValidateThis.server.serverrulevalidator_boolean",GetMetadata(SRVs.Boolean).name);
			assertTrue(StructKeyExists(SRVs.Boolean,"validate"));
			assertEquals(true,structKeyExists(SRVs,"Custom"));
			assertEquals(true,structKeyExists(SRVs,"Extra"));
			assertEquals("vtdemo.unittests.fixture.overrideserverrulevalidators.serverrulevalidator_custom",GetMetadata(SRVs.Custom).name);
			assertEquals("vtdemo.unittests.fixture.overrideserverrulevalidators.serverrulevalidator_extra",GetMetadata(SRVs.Extra).name);
			assertTrue(StructKeyExists(SRVs.Custom,"validate"));
			assertTrue(StructKeyExists(SRVs.Extra,"validate"));
		</cfscript>
	</cffunction>

	<!---

	<cffunction name="OverrideRuleValidatorsShouldBeLoaded" access="public" returntype="void">
		<cfscript>
			ServerValidator = CreateObject("component","ValidateThis.server.ServerValidator").init(FileSystem,TransientFactory,ObjectChecker,"VTDemo.UnitTests.Fixture.OverrideServerRuleValidators");
			RuleValidators = ServerValidator.getRuleValidators();
			assertEquals(true,structKeyExists(RuleValidators,"Custom"));
			assertEquals(true,structKeyExists(RuleValidators,"Extra"));
			assertEquals("vtdemo.unittests.fixture.overrideserverrulevalidators.serverrulevalidator_custom",GetMetadata(RuleValidators.Custom).name);
			assertEquals("vtdemo.unittests.fixture.overrideserverrulevalidators.serverrulevalidator_extra",GetMetadata(RuleValidators.Extra).name);
			assertTrue(StructKeyExists(RuleValidators.Custom,"validate"));
		</cfscript>  
	</cffunction>
	--->
	
	<cffunction name="newResultShouldReturnBuiltInResultObjectWithDefaultConfig" access="public" returntype="void">
		<cfscript>
			result = validationFactory.newResult();
			assertEquals("validatethis.util.Result",GetMetadata(result).name);
		</cfscript>
	</cffunction>

	<cffunction name="newResultShouldReturnCustomResultObjectWhenspecifiedViaConfig" access="public" returntype="void">
		<cfscript>
			ValidateThisConfig.ResultPath="UnitTests.Fixture.CustomResult";
			validationFactory = CreateObject("component","ValidateThis.core.ValidationFactory").init(ValidateThisConfig);
			result = validationFactory.newResult();
			assertEquals("UnitTests.Fixture.CustomResult",GetMetadata(result).name);
		</cfscript>
	</cffunction>

	<cffunction name="getValidatorShouldReturnProperBOWhenXmlRulesFileIsAlongsideCFC" access="public" returntype="void">
		<cfscript>
			theObject = createObject("component","Fixture.APlainCFC_Fixture");
			BOValidator = validationFactory.getValidator(objectType=ListLast(getMetaData(theObject).Name,"."),definitionPath=getDirectoryFromPath(getMetadata(theObject).path));
			allContexts = BOValidator.getAllContexts();
			assertEquals(true,structKeyExists(allContexts,"___Default"));
			assertEquals("firstName",allContexts.___Default[1].propertyName);
			assertEquals("lastName",allContexts.___Default[2].propertyName);
		</cfscript>  
	</cffunction>

	<cffunction name="getValidatorShouldReturnProperBOWhenXmlCfmRulesFileIsAlongsideCFC" access="public" returntype="void">
		<cfscript>
			theObject = createObject("component","Fixture.APlainCFC_Fixture_cfm");
			BOValidator = validationFactory.getValidator(objectType=ListLast(getMetaData(theObject).Name,"."),definitionPath=getDirectoryFromPath(getMetadata(theObject).path));
			allContexts = BOValidator.getAllContexts();
			assertEquals(true,structKeyExists(allContexts,"___Default"));
			assertEquals("firstName",allContexts.___Default[1].propertyName);
			assertEquals("lastName",allContexts.___Default[2].propertyName);
		</cfscript>  
	</cffunction>

	<cffunction name="getValidatorShouldReturnProperBOWhenXmlFileIsInAConfiguredFolder" access="public" returntype="void">
		<cfscript>
			ValidateThisConfig.definitionPath = getDirectoryFromPath(getCurrentTemplatePath()) & "Fixture/Rules/";
			validationFactory = CreateObject("component","ValidateThis.core.ValidationFactory").init(ValidateThisConfig);
			theObject = createObject("component","Fixture.ObjectWithSeparateRulesFile");
			BOValidator = validationFactory.getValidator(objectType=ListLast(getMetaData(theObject).Name,"."),definitionPath=getDirectoryFromPath(getMetadata(theObject).path));
			allContexts = BOValidator.getAllContexts();
			assertEquals(true,structKeyExists(allContexts,"___Default"));
			assertEquals("firstName",allContexts.___Default[1].propertyName);
			assertEquals("lastName",allContexts.___Default[2].propertyName);
		</cfscript>  
	</cffunction>

	<cffunction name="getValidatorShouldReturnProperBOWithoutAnnotationsWhenXmlRulesFileIsAlongsideCFCAndActualObjectIsPassedIn" access="public" returntype="void">
		<cfscript>
			theObject = createObject("component","Fixture.APlainCFC_Fixture");
			BOValidator = validationFactory.getValidator(objectType=ListLast(getMetaData(theObject).Name,"."),definitionPath=getDirectoryFromPath(getMetadata(theObject).path),theObject=theObject);
			allContexts = BOValidator.getAllContexts();
			assertEquals(true,structKeyExists(allContexts,"___Default"));
			assertEquals("firstName",allContexts.___Default[1].propertyName);
			assertEquals("lastName",allContexts.___Default[2].propertyName);
		</cfscript>  
	</cffunction>

</cfcomponent>

