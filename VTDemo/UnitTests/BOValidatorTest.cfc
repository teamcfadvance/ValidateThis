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
			setBeanFactory(forceRefresh=true);
			variables.ValidateThis = getBeanFactory().getBean("ValidateThis");
			variables.className = "user.user";
		</cfscript>  
	</cffunction>

	<cffunction name="tearDown" access="public" returntype="void">
	</cffunction>

	<cffunction name="initReturnsCorrectObjectWithExplicitExpandedPath" access="public" returntype="void">
		<cfscript>
			defPath = ReReplaceNoCase(getCurrentTemplatePath(),"([\w\/]+?)(UnitTests\/)([\w\W]+)","\1BODemo/Model/");
			BOValidator = variables.ValidateThis.getValidator(variables.className,defPath);
			isBOVCorrect(BOValidator);
		</cfscript>  
	</cffunction>

	<cffunction name="initThrowsWithBadExplicitExpandedPath" access="public" returntype="void" mxunit:expectedException="ValidateThis.core.XMLFileReader.definitionPathNotFound">
		<cfscript>
			defPath = ReReplaceNoCase(getCurrentTemplatePath(),"([\w\/]+?)(UnitTests\/)([\w\W]+)","\1BODemo/Model/") & "_Doesnt_Exist/";
			BOValidator = variables.ValidateThis.getValidator(variables.className,defPath);
		</cfscript>  
	</cffunction>

	<cffunction name="initReturnsCorrectObjectWithExplicitMappedPath" access="public" returntype="void">
		<cfscript>
			defPath = "/BODemo/Model/";
			BOValidator = variables.ValidateThis.getValidator(variables.className,defPath);
			isBOVCorrect(BOValidator);
		</cfscript>  
	</cffunction>

	<cffunction name="initThrowsWithBadExplicitMappedPath" access="public" returntype="void" mxunit:expectedException="ValidateThis.core.XMLFileReader.definitionPathNotFound">
		<cfscript>
			defPath = "/BODemo/Model_Doesnt_Exist/";
			BOValidator = variables.ValidateThis.getValidator(variables.className,defPath);
		</cfscript>  
	</cffunction>

	<cffunction name="initReturnsCorrectObjectWithMappingInValidateThisConfig" access="public" returntype="void">
		<cfscript>
			ValidateThisConfig = {definitionPath="/BODemo/Model/"};
			variables.ValidateThis = getBeanFactory().getBean("ValidateThis").init(ValidateThisConfig);
			BOValidator = variables.ValidateThis.getValidator(variables.className);
			isBOVCorrect(BOValidator);
		</cfscript>  
	</cffunction>

	<cffunction name="initThrowsWithBadMappingInValidateThisConfig" access="public" returntype="void" mxunit:expectedException="ValidateThis.core.XMLFileReader.definitionPathNotFound">
		<cfscript>
			ValidateThisConfig = {definitionPath="/BODemo/Model_Doesnt_Exist/"};
			variables.ValidateThis = getBeanFactory().getBean("ValidateThis").init(ValidateThisConfig);
			BOValidator = variables.ValidateThis.getValidator(variables.className);
		</cfscript>  
	</cffunction>

	<cffunction name="initReturnsCorrectObjectWithPhysicalPathInValidateThisConfig" access="public" returntype="void">
		<cfscript>
			ValidateThisConfig = {definitionPath=ReReplaceNoCase(getCurrentTemplatePath(),"([\w\/]+?)(UnitTests\/)([\w\W]+)","\1BODemo/Model/")};
			variables.ValidateThis = getBeanFactory().getBean("ValidateThis").init(ValidateThisConfig);
			BOValidator = variables.ValidateThis.getValidator(variables.className);
			isBOVCorrect(BOValidator);
		</cfscript>  
	</cffunction>

	<cffunction name="initThrowsWithBadPhysicalPathInValidateThisConfig" access="public" returntype="void" mxunit:expectedException="ValidateThis.core.XMLFileReader.definitionPathNotFound">
		<cfscript>
			ValidateThisConfig = {definitionPath=ReReplaceNoCase(getCurrentTemplatePath(),"([\w\/]+?)(UnitTests\/)([\w\W]+)","\1BODemo/Model/") & "Doesnt_Exist/"};
			variables.ValidateThis = getBeanFactory().getBean("ValidateThis").init(ValidateThisConfig);
			BOValidator = variables.ValidateThis.getValidator(variables.className);
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

	<cffunction name="initShouldReturnProperObjectWhenXmlRulesFileIsAlongsideCFC" access="public" returntype="void">
		<cfscript>
			theObject = createObject("component","Fixture.APlainCFC_Fixture");
			BOValidator = variables.ValidateThis.getValidator(theObject=theObject);
			allContexts = BOValidator.getAllContexts();
			assertEquals(true,structKeyExists(allContexts,"___Default"));
			assertEquals("firstName",allContexts.___Default[1].propertyName);
			assertEquals("lastName",allContexts.___Default[2].propertyName);
		</cfscript>  
	</cffunction>

	<cffunction name="getValidatorShouldReturnProperBOWhenXmlCfmRulesFileIsAlongsideCFC" access="public" returntype="void">
		<cfscript>
			theObject = createObject("component","Fixture.APlainCFC_Fixture_cfm");
			BOValidator = variables.ValidateThis.getValidator(theObject=theObject);
			allContexts = BOValidator.getAllContexts();
			assertEquals(true,structKeyExists(allContexts,"___Default"));
			assertEquals("firstName",allContexts.___Default[1].propertyName);
			assertEquals("lastName",allContexts.___Default[2].propertyName);
		</cfscript>  
	</cffunction>

	<cffunction name="getValidatorShouldReturnProperBOWhenXmlFileIsInAConfiguredFolder" access="public" returntype="void">
		<cfscript>
			VTConfig = 	{definitionPath=getDirectoryFromPath(getCurrentTemplatePath()) & "Fixture/Rules/"};
			ValidateThis = CreateObject("component","ValidateThis.ValidateThis").init(VTConfig);
			theObject = createObject("component","Fixture.ObjectWithSeparateRulesFile");
			BOValidator = variables.ValidateThis.getValidator(theObject=theObject);
			allContexts = BOValidator.getAllContexts();
			assertEquals(true,structKeyExists(allContexts,"___Default"));
			assertEquals("firstName",allContexts.___Default[1].propertyName);
			assertEquals("lastName",allContexts.___Default[2].propertyName);
		</cfscript>  
	</cffunction>

	<cffunction name="createDefaultBOV" access="private" returntype="any">
		<cfscript>
			// Note, the following contains hardcoded path delimeters - had to change when moving to a Mac
			defPath = ReReplaceNoCase(getCurrentTemplatePath(),"([\w\/]+?)(UnitTests\/)([\w\W]+)","\1BODemo/Model/");
			return variables.ValidateThis.getValidator(variables.className,defPath);
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

