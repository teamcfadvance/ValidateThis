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
			variables.className = "user";
		</cfscript>  
	</cffunction>

	<cffunction name="tearDown" access="public" returntype="void">
	</cffunction>

	<cffunction name="initReturnsCorrectObjectWithExplicitExpandedPath" access="public" returntype="void">
		<cfscript>
			defPath = getDirectoryFromPath(getCurrentTemplatePath()) & "Fixture";
			BOValidator = validationFactory.getValidator(variables.className,defPath);
			isBOVCorrect(BOValidator);
		</cfscript>  
	</cffunction>

	<cffunction name="initThrowsWithBadExplicitExpandedPath" access="public" returntype="void" mxunit:expectedException="ValidateThis.core.externalFileReader.definitionPathNotFound">
		<cfscript>
			defPath = getDirectoryFromPath(getCurrentTemplatePath()) & "Fixture" & "_Doesnt_Exist/";
			BOValidator = validationFactory.getValidator(variables.className,defPath);
		</cfscript>  
	</cffunction>

	<cffunction name="initReturnsCorrectObjectWithExplicitMappedPath" access="public" returntype="void">
		<cfscript>
			defPath = "/UnitTests/Fixture";
			BOValidator = validationFactory.getValidator(variables.className,defPath);
			isBOVCorrect(BOValidator);
		</cfscript>  
	</cffunction>

	<cffunction name="initThrowsWithBadExplicitMappedPath" access="public" returntype="void" mxunit:expectedException="ValidateThis.core.externalFileReader.definitionPathNotFound">
		<cfscript>
			defPath = "/VTDemo/UnitTests/Fixture/_Doesnt_Exist/";
			BOValidator = validationFactory.getValidator(variables.className,defPath);
		</cfscript>  
	</cffunction>

	<cffunction name="initReturnsCorrectObjectWithMappingInValidateThisConfig" access="public" returntype="void">
		<cfscript>
			ValidateThisConfig.definitionPath = "/UnitTests/Fixture";
			validationFactory = CreateObject("component","ValidateThis.core.ValidationFactory").init(ValidateThisConfig);
			BOValidator = validationFactory.getValidator(variables.className);
			isBOVCorrect(BOValidator);
		</cfscript>  
	</cffunction>

	<cffunction name="initThrowsWithBadMappingInValidateThisConfig" access="public" returntype="void" mxunit:expectedException="ValidateThis.core.externalFileReader.definitionPathNotFound">
		<cfscript>
			ValidateThisConfig.definitionPath = "/VTDemo/UnitTests/Fixture/_DoesntExist";
			validationFactory = CreateObject("component","ValidateThis.core.ValidationFactory").init(ValidateThisConfig);
			BOValidator = validationFactory.getValidator(variables.className);
		</cfscript>  
	</cffunction>

	<cffunction name="initReturnsCorrectObjectWithPhysicalPathInValidateThisConfig" access="public" returntype="void">
		<cfscript>
			ValidateThisConfig.definitionPath = getDirectoryFromPath(getCurrentTemplatePath()) & "Fixture";
			validationFactory = CreateObject("component","ValidateThis.core.ValidationFactory").init(ValidateThisConfig);
			BOValidator = validationFactory.getValidator(variables.className);
			isBOVCorrect(BOValidator);
		</cfscript>  
	</cffunction>

	<cffunction name="initThrowsWithBadPhysicalPathInValidateThisConfig" access="public" returntype="void" mxunit:expectedException="ValidateThis.core.externalFileReader.definitionPathNotFound">
		<cfscript>
			ValidateThisConfig.definitionPath = getDirectoryFromPath(getCurrentTemplatePath()) & "Fixture" & "DoesntExist";
			validationFactory = CreateObject("component","ValidateThis.core.ValidationFactory").init(ValidateThisConfig);
			BOValidator = validationFactory.getValidator(variables.className);
		</cfscript>  
	</cffunction>

	<cffunction name="getRequiredPropertiesReturnsCorrectStruct" access="public" returntype="void">
		<cfscript>
			BOValidator = createDefaultBOV();
			FieldList = BOValidator.getRequiredProperties();
			assertEquals(4,structCount(FieldList));
			assertTrue(ListFindNoCase(StructKeyList(FieldList),"UserName"));
			assertTrue(ListFindNoCase(StructKeyList(FieldList),"VerifyPassword"));
			assertTrue(ListFindNoCase(StructKeyList(FieldList),"UserGroup"));
			assertTrue(ListFindNoCase(StructKeyList(FieldList),"UserPass"));
			FieldList = BOValidator.getRequiredProperties("Register");
			assertEquals(4,structCount(FieldList));
			assertTrue(ListFindNoCase(StructKeyList(FieldList),"UserName"));
			assertTrue(ListFindNoCase(StructKeyList(FieldList),"VerifyPassword"));
			assertTrue(ListFindNoCase(StructKeyList(FieldList),"UserGroup"));
			assertTrue(ListFindNoCase(StructKeyList(FieldList),"UserPass"));
			FieldList = BOValidator.getRequiredProperties("Profile");
			assertEquals(7,structCount(FieldList));
			assertTrue(ListFindNoCase(StructKeyList(FieldList),"UserName"));
			assertTrue(ListFindNoCase(StructKeyList(FieldList),"VerifyPassword"));
			assertTrue(ListFindNoCase(StructKeyList(FieldList),"UserGroup"));
			assertTrue(ListFindNoCase(StructKeyList(FieldList),"UserPass"));
			assertTrue(ListFindNoCase(StructKeyList(FieldList),"FirstName"));
			assertTrue(ListFindNoCase(StructKeyList(FieldList),"LastName"));
			assertTrue(ListFindNoCase(StructKeyList(FieldList),"Salutation"));
		</cfscript>  
	</cffunction>

	<cffunction name="getRequiredFieldsReturnsCorrectStruct" access="public" returntype="void">
		<cfscript>
			BOValidator = createDefaultBOV();
			FieldList = BOValidator.getRequiredFields("Register");
			assertEquals(4,structCount(FieldList));
			assertTrue(ListFindNoCase(StructKeyList(FieldList),"UserName"));
			assertTrue(ListFindNoCase(StructKeyList(FieldList),"VerifyPassword"));
			assertTrue(ListFindNoCase(StructKeyList(FieldList),"UserGroupId"));
			assertTrue(ListFindNoCase(StructKeyList(FieldList),"UserPass"));
			FieldList = BOValidator.getRequiredFields("Profile");
			assertEquals(7,structCount(FieldList));
			assertTrue(ListFindNoCase(StructKeyList(FieldList),"UserName"));
			assertTrue(ListFindNoCase(StructKeyList(FieldList),"VerifyPassword"));
			assertTrue(ListFindNoCase(StructKeyList(FieldList),"UserGroupId"));
			assertTrue(ListFindNoCase(StructKeyList(FieldList),"UserPass"));
			assertTrue(ListFindNoCase(StructKeyList(FieldList),"FirstName"));
			assertTrue(ListFindNoCase(StructKeyList(FieldList),"LastName"));
			assertTrue(ListFindNoCase(StructKeyList(FieldList),"Salutation"));
		</cfscript>  
	</cffunction>

	<cffunction name="getAllContextsReturnsCorrectStruct" access="public" returntype="void">
		<cfscript>
			BOValidator = createDefaultBOV();
			AllContexts = BOValidator.getAllContexts();
			assertTrue(ListFindNoCase(StructKeyList(AllContexts),"Profile"));
			assertTrue(ListFindNoCase(StructKeyList(AllContexts),"___Default"));
			assertTrue(ListFindNoCase(StructKeyList(AllContexts),"Register"));
		</cfscript>  
	</cffunction>

	<cffunction name="getVersionReturnsCurrentVersion" access="public" returntype="void">
		<cfscript>
			BOValidator = createDefaultBOV();
			assertEquals("0.94",BOValidator.getVersion());
		</cfscript>  
	</cffunction>
	
	<cffunction name="propertyIsRequiredWithDefaultContextShouldReturnTrueIfPropertyIsRequired" access="public" returntype="void">
		<cfscript>
			BOValidator = createDefaultBOV();
			assertEquals(true,BOValidator.propertyIsRequired("UserName"));
		</cfscript>  
	</cffunction>
	
	<cffunction name="propertyIsRequiredWithDefaultContextShouldReturnFalseIfPropertyIsNotRequired" access="public" returntype="void">
		<cfscript>
			BOValidator = createDefaultBOV();
			assertEquals(false,BOValidator.propertyIsRequired("Nickname"));
		</cfscript>  
	</cffunction>
	
	<cffunction name="propertyIsRequiredWithSpecificContextShouldReturnTrueIfPropertyIsRequired" access="public" returntype="void">
		<cfscript>
			BOValidator = createDefaultBOV();
			assertEquals(true,BOValidator.propertyIsRequired("FirstName","Profile"));
		</cfscript>  
	</cffunction>
	
	<cffunction name="propertyIsRequiredWithSpecificContextShouldReturnFalseIfPropertyIsNotRequired" access="public" returntype="void">
		<cfscript>
			BOValidator = createDefaultBOV();
			assertEquals(false,BOValidator.propertyIsRequired("FirstName","Register"));
		</cfscript>  
	</cffunction>

	<cffunction name="createDefaultBOV" access="private" returntype="any">
		<cfscript>
			// Note, the following contains hardcoded path delimeters - had to change when moving to a Mac
			defPath = getDirectoryFromPath(getCurrentTemplatePath()) & "Fixture";
			return validationFactory.getValidator(variables.className,defPath);
		</cfscript>  
	</cffunction>

	<cffunction name="isBOVCorrect" access="private" returntype="void">
		<cfargument name="BOValidator">
		<cfscript>
			AllContexts = arguments.BOValidator.getAllContexts();
			assertTrue(ListFindNoCase(StructKeyList(AllContexts),"Profile"));
			assertTrue(ListFindNoCase(StructKeyList(AllContexts),"___Default"));
			assertTrue(ListFindNoCase(StructKeyList(AllContexts),"Register"));
		</cfscript>  
	</cffunction>

</cfcomponent>

