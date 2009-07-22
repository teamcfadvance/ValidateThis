<!---
	
filename:		\VTDemo\UnitTests\BOValidatorTest.cfc
date created:	2008-10-22
author:			Bob Silverberg (http://www.silverwareconsulting.com/)
purpose:		I BOValidatorTest.cfc
				
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
<cfcomponent displayname="UnitTests.BOValidatorTest" extends="UnitTests.BaseTestCase" output="false">
	
	<cffunction name="setUp" access="public" returntype="void">
		<cfscript>
			setBeanFactory();
			variables.ValidateThis = getBeanFactory().getBean("ValidateThis");
			variables.className = "user.user";
			// Note, the following contains hardcoded path delimeters - had to change when moving to a Mac
			defPath = ReReplaceNoCase(getCurrentTemplatePath(),"([\w\/]+?)(UnitTests\/)([\w\W]+)","\1BODemo/Model/");
			variables.BOValidator = ValidateThis.getValidator(variables.className,defPath);
		</cfscript>  
	</cffunction>

	<cffunction name="tearDown" access="public" returntype="void">
	</cffunction>

	<cffunction name="initReturnsCorrectObjectWithExplicitExpandedPath" access="public" returntype="void">
		<cfscript>
			defPath = ReReplaceNoCase(getCurrentTemplatePath(),"([\w\/]+?)(UnitTests\/)([\w\W]+)","\1BODemo/Model/");
			variables.BOValidator = ValidateThis.getValidator(variables.className,defPath);
			isBOCorrect();
		</cfscript>  
	</cffunction>

	<cffunction name="initReturnsCorrectObjectWithMappingInValidateThisConfig" access="public" returntype="void">
		<cfscript>
			ValidateThisConfig = {definitionPath="/BODemo/Model/"};
			variables.ValidateThis = getBeanFactory().getBean("ValidateThis").init(ValidateThisConfig);
			variables.BOValidator = ValidateThis.getValidator(variables.className);
			isBOCorrect();
		</cfscript>  
	</cffunction>

	<cffunction name="initReturnsCorrectObjectWithPhysicalPathInValidateThisConfig" access="public" returntype="void">
		<cfscript>
			ValidateThisConfig = {definitionPath=ReReplaceNoCase(getCurrentTemplatePath(),"([\w\/]+?)(UnitTests\/)([\w\W]+)","\1BODemo/Model/")};
			variables.ValidateThis = getBeanFactory().getBean("ValidateThis").init(ValidateThisConfig);
			variables.BOValidator = ValidateThis.getValidator(variables.className);
			isBOCorrect();
		</cfscript>  
	</cffunction>

	<cffunction name="getRequiredPropertiesReturnsCorrectStruct" access="public" returntype="void">
		<cfscript>
			FieldList = BOValidator.getRequiredProperties("Register");
			assertTrue(ListFindNoCase(StructKeyList(FieldList),"UserName"));
			assertTrue(ListFindNoCase(StructKeyList(FieldList),"VerifyPassword"));
			assertTrue(ListFindNoCase(StructKeyList(FieldList),"UserGroup"));
			assertTrue(ListFindNoCase(StructKeyList(FieldList),"UserPass"));
		</cfscript>  
	</cffunction>

	<cffunction name="getAllContextsReturnsCorrectStruct" access="public" returntype="void">
		<cfscript>
			AllContexts = BOValidator.getAllContexts();
			assertTrue(ListFindNoCase(StructKeyList(AllContexts),"Profile"));
			assertTrue(ListFindNoCase(StructKeyList(AllContexts),"___Default"));
			assertTrue(ListFindNoCase(StructKeyList(AllContexts),"Register"));
		</cfscript>  
	</cffunction>

	<cffunction name="isBOCorrect" access="private" returntype="void">
		<cfscript>
			AllContexts = BOValidator.getAllContexts();
			assertTrue(ListFindNoCase(StructKeyList(AllContexts),"Profile"));
			assertTrue(ListFindNoCase(StructKeyList(AllContexts),"___Default"));
			assertTrue(ListFindNoCase(StructKeyList(AllContexts),"Register"));
		</cfscript>  
	</cffunction>

</cfcomponent>

