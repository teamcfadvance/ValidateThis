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
	
	<cfset externalFileReader = "" />
	
	<cffunction name="setUp" access="public" returntype="void">
		<cfscript>
			ValidateThisConfig = getVTConfig();
			className = "user";
			validationFactory = CreateObject("component","ValidateThis.core.ValidationFactory").init(ValidateThisConfig);
			externalFileReader = validationFactory.getBean("externalFileReader");
		</cfscript>
	</cffunction>

	<cffunction name="tearDown" access="public" returntype="void">
	</cffunction>

	<cffunction name="localFileReadersShouldLoadOnInit" access="public" returntype="void">
		<cfscript>
			validationFactory = CreateObject("component","ValidateThis.core.ValidationFactory").init(ValidateThisConfig);
			externalFileReader = validationFactory.getBean("externalFileReader");
			makePublic(externalFileReader,"getFileReaders");
			FRs = externalFileReader.getFileReaders();
			assertEquals(true,structKeyExists(FRs,"XML"));
			assertTrue(GetMetadata(FRs.XML).name CONTAINS "FileReader_XML");
			assertTrue(GetMetadata(FRs.XML).name CONTAINS "ValidateThis");
			assertEquals(true,structKeyExists(FRs,"JSON"));
			assertTrue(GetMetadata(FRs.JSON).name CONTAINS "FileReader_JSON");
			assertTrue(GetMetadata(FRs.JSON).name CONTAINS "ValidateThis");
		</cfscript>  
	</cffunction>

	<cffunction name="ExtraFileReadersShouldLoadOnInit" access="public" returntype="void">
		<cfscript>
			ValidateThisConfig.extraFileReaderComponentPaths="VTDemo.UnitTests.Fixture.FileReaders";
			validationFactory = CreateObject("component","ValidateThis.core.ValidationFactory").init(ValidateThisConfig);
			externalFileReader = validationFactory.getBean("externalFileReader");
			makePublic(externalFileReader,"getFileReaders");
			FRs = externalFileReader.getFileReaders();
			assertEquals(true,structKeyExists(FRs,"XML"));
			assertTrue(GetMetadata(FRs.XML).name CONTAINS "FileReader_XML");
			assertTrue(GetMetadata(FRs.XML).name CONTAINS "ValidateThis");
			assertEquals(true,structKeyExists(FRs,"Extra"));
			assertTrue(GetMetadata(FRs.Extra).name CONTAINS "FileReader_Extra");
			assertTrue(GetMetadata(FRs.Extra).name CONTAINS "Fixture");
		</cfscript>  
	</cffunction>

	<cffunction name="OverrideFileReadersShouldLoadOnInit" access="public" returntype="void">
		<cfscript>
			ValidateThisConfig.extraFileReaderComponentPaths="VTDemo.UnitTests.Fixture.OverrideFileReaders";
			validationFactory = CreateObject("component","ValidateThis.core.ValidationFactory").init(ValidateThisConfig);
			externalFileReader = validationFactory.getBean("externalFileReader");
			makePublic(externalFileReader,"getFileReaders");
			FRs = externalFileReader.getFileReaders();
			assertEquals(true,structKeyExists(FRs,"XML"));
			assertTrue(GetMetadata(FRs.XML).name CONTAINS "FileReader_XML");
			assertTrue(GetMetadata(FRs.XML).name CONTAINS "Fixture");
			assertEquals(true,structKeyExists(FRs,"Extra"));
			assertTrue(GetMetadata(FRs.Extra).name CONTAINS "FileReader_Extra");
			assertTrue(GetMetadata(FRs.Extra).name CONTAINS "Fixture");
		</cfscript>  
	</cffunction>

	<cffunction name="processFilesReturnsCorrectStructForJSONFile" access="public" returntype="void">
		<cfscript>
			defPath = getDirectoryFromPath(getCurrentTemplatePath()) & "Fixture/Rules/json";
			debug(externalFileReader.processFiles(className,defPath));
			PropertyDescs = externalFileReader.processFiles(className,defPath).PropertyDescs;
			isPropertiesStructCorrect(PropertyDescs);
		</cfscript>  
	</cffunction>

	<cffunction name="processFilesReturnsCorrectStructWithMappedPathLookingForXMLExtension" access="public" returntype="void">
		<cfscript>
			defPath = "/UnitTests/Fixture";
			PropertyDescs = externalFileReader.processFiles(className,defPath).PropertyDescs;
			isPropertiesStructCorrect(PropertyDescs);
		</cfscript>  
	</cffunction>

	<cffunction name="processFilesReturnsCorrectStructWithPhysicalPathLookingForXMLExtension" access="public" returntype="void">
		<cfscript>
			defPath = getDirectoryFromPath(getCurrentTemplatePath()) & "Fixture";
			PropertyDescs = externalFileReader.processFiles(className,defPath).PropertyDescs;
			isPropertiesStructCorrect(PropertyDescs);
		</cfscript>  
	</cffunction>

	<cffunction name="processFilesReturnsCorrectStructWithMappedPathLookingForXMLCFMExtension" access="public" returntype="void">
		<cfscript>
			defPath = "/UnitTests/Fixture";
			PropertyDescs = externalFileReader.processFiles("user_cfm",defPath).PropertyDescs;
			isPropertiesStructCorrect(PropertyDescs);
		</cfscript>  
	</cffunction>

	<cffunction name="processFilesReturnsCorrectStructWithPhysicalPathLookingForXMLCFMExtension" access="public" returntype="void">
		<cfscript>
			defPath = getDirectoryFromPath(getCurrentTemplatePath()) & "Fixture";
			PropertyDescs = externalFileReader.processFiles("user_cfm",defPath).PropertyDescs;
			isPropertiesStructCorrect(PropertyDescs);
		</cfscript>  
	</cffunction>

	<cffunction name="processFilesReturnsCorrectStructLookingForXMLExtensionInFolder" access="public" returntype="void">
		<cfscript>
			defPath = "/UnitTests/Fixture";
			PropertyDescs = externalFileReader.processFiles("user.user_folder",defPath).PropertyDescs;
			isPropertiesStructCorrect(PropertyDescs);
		</cfscript>  
	</cffunction>

	<cffunction name="processFilesReturnsCorrectStructLookingForXMLCFMExtensionInFolder" access="public" returntype="void">
		<cfscript>
			defPath = "/UnitTests/Fixture";
			PropertyDescs = externalFileReader.processFiles("user_cfm.user_cfm_folder",defPath).PropertyDescs;
			isPropertiesStructCorrect(PropertyDescs);
		</cfscript>  
	</cffunction>

	<cffunction name="processFilesReturnsCorrectStructLookingForFileInSecondFolderInList" access="public" returntype="void">
		<cfscript>
			defPath = "/UnitTests/Fixture,/UnitTests/Fixture/aSecondFolderToTest";
			PropertyDescs = externalFileReader.processFiles("user.user_secondfolder",defPath).PropertyDescs;
			isPropertiesStructCorrect(PropertyDescs);
		</cfscript>  
	</cffunction>

	<cffunction name="processFilesThrowsWithBadMappedPath" access="public" returntype="void" mxunit:expectedException="ValidateThis.core.externalFileReader.definitionPathNotFound">
		<cfscript>
			defPath = "/UnitTests/Fixture/Model_Doesnt_Exist/";
			PropertyDescs = externalFileReader.processFiles(className,defPath).PropertyDescs;
			isPropertiesStructCorrect(PropertyDescs);
		</cfscript>  
	</cffunction>

	<cffunction name="processFilesThrowsWithBadPhysicalPath" access="public" returntype="void" mxunit:expectedException="ValidateThis.core.externalFileReader.definitionPathNotFound">
		<cfscript>
			defPath = getDirectoryFromPath(getCurrentTemplatePath()) & "Fixture" & "Doesnt_Exist/";
			PropertyDescs = externalFileReader.processFiles(className,defPath).PropertyDescs;
			isPropertiesStructCorrect(PropertyDescs);
		</cfscript>  
	</cffunction>

	<cffunction name="processFilesReturnsCorrectStructWithMappedPathWithoutTrailingSlash" access="public" returntype="void">
		<cfscript>
			defPath = "/UnitTests/Fixture";
			PropertyDescs = externalFileReader.processFiles(className,defPath).PropertyDescs;
			isPropertiesStructCorrect(PropertyDescs);
		</cfscript>  
	</cffunction>

	<cffunction name="processFilesReturnsCorrectStructWithMappedPathWithTrailingSlash" access="public" returntype="void">
		<cfscript>
			defPath = "/UnitTests/Fixture/";
			PropertyDescs = externalFileReader.processFiles(className,defPath).PropertyDescs;
			isPropertiesStructCorrect(PropertyDescs);
		</cfscript>  
	</cffunction>

	<cffunction name="processFilesReturnsCorrectPropertyDescs" access="public" returntype="void">
		<cfscript>
			className = "user";
			definitionPath = ExpandPath("/UnitTests/Fixture");
			PropertyDescs = externalFileReader.processFiles(className,definitionPath).PropertyDescs;
			isPropertiesStructCorrect(PropertyDescs);
		</cfscript>  
	</cffunction>

	<cffunction name="processFilesReturnsCorrectValidations" access="public" returntype="void">
		<cfscript>
			className = "user";
			definitionPath = ExpandPath("/UnitTests/Fixture");
			Validations = externalFileReader.processFiles(className,definitionPath).Validations;
			assertEquals(StructCount(Validations),1);
			assertEquals(StructCount(Validations.Contexts),3);
			Rules = Validations.Contexts.Register;
			assertEquals(ArrayLen(Rules),13);
			Validation = Rules[1];
			assertEquals(Validation.ValType,"required");
			assertEquals(Validation.PropertyName,"LastName");
			assertEquals(Validation.PropertyDesc,"Last Name");
			assertEquals(Validation.Parameters.DependentPropertyName,"FirstName");
			assertEquals(Validation.Parameters.DependentPropertyDesc,"First Name");
			Validation = Rules[2];
			assertEquals(Validation.ValType,"required");
			assertEquals(Validation.PropertyName,"UserName");
			assertEquals(Validation.PropertyDesc,"Email Address");
			Validation = Rules[3];
			assertEquals(Validation.ValType,"email");
			assertEquals(Validation.PropertyName,"UserName");
			assertEquals(Validation.PropertyDesc,"Email Address");
			assertEquals(Validation.FailureMessage,"Hey, buddy, you call that an Email Address?");
			Validation = Rules[4];
			assertEquals(Validation.ValType,"custom");
			assertEquals(Validation.PropertyName,"Nickname");
			assertEquals(Validation.PropertyDesc,"Nickname");
			assertEquals(Validation.Parameters.MethodName,"CheckDupNickname");
			Validation = Rules[5];
			assertEquals(Validation.ValType,"required");
			assertEquals(Validation.PropertyName,"UserPass");
			assertEquals(Validation.PropertyDesc,"Password");
			Validation = Rules[6];
			assertEquals(Validation.ValType,"rangelength");
			assertEquals(Validation.PropertyName,"UserPass");
			assertEquals(Validation.PropertyDesc,"Password");
			assertEquals(Validation.Parameters.MinLength,5);
			assertEquals(Validation.Parameters.MaxLength,10);
			Validation = Rules[7];
			assertEquals(Validation.ValType,"required");
			assertEquals(Validation.PropertyName,"VerifyPassword");
			assertEquals(Validation.PropertyDesc,"Verify Password");
			Validation = Rules[8];
			assertEquals(Validation.ValType,"equalTo");
			assertEquals(Validation.PropertyName,"VerifyPassword");
			assertEquals(Validation.PropertyDesc,"Verify Password");
			assertEquals(Validation.Parameters.ComparePropertyName,"UserPass");
			assertEquals(Validation.Parameters.ComparePropertyDesc,"Password");
			Validation = Rules[9];
			assertEquals(Validation.ValType,"required");
			assertEquals(Validation.PropertyName,"UserGroup");
			assertEquals(Validation.PropertyDesc,"User Group");
			Validation = Rules[10];
			assertEquals(Validation.ValType,"regex");
			assertEquals(Validation.PropertyName,"Salutation");
			assertEquals(Validation.PropertyDesc,"Salutation");
			assertEquals(Validation.Parameters.Regex,"^(Dr|Prof|Mr|Mrs|Ms|Miss)(\.)?$");
			assertEquals(Validation.FailureMessage,"Only Dr, Prof, Mr, Mrs, Ms, or Miss (with or without a period) are allowed.");
			Validation = Rules[11];
			assertEquals(Validation.ValType,"required");
			assertEquals(Validation.PropertyName,"LikeOther");
			assertEquals(Validation.PropertyDesc,"What do you like?");
			assertEquals(Validation.FailureMessage,"If you don't like Cheese and you don't like Chocolate, you must like something!");
			assertEquals(Validation.Condition.ClientTest,"$(""[name='LikeCheese']"").getValue() == 0 && $(""[name='LikeChocolate']"").getValue() == 0;");
			assertEquals(Validation.Condition.ServerTest,"getLikeCheese() EQ 0 AND getLikeChocolate() EQ 0");
			Validation = Rules[12];
			assertEquals(Validation.ValType,"numeric");
			assertEquals(Validation.PropertyName,"HowMuch");
			assertEquals(Validation.PropertyDesc,"How much money would you like?");
			Validation = Rules[13];
			assertEquals(Validation.ValType,"required");
			assertEquals(Validation.PropertyName,"CommunicationMethod");
			assertEquals(Validation.PropertyDesc,"Communication Method");
			assertEquals(Validation.Parameters.DependentPropertyDesc,"Allow Communication");
			assertEquals(Validation.Parameters.DependentPropertyName,"AllowCommunication");
			assertEquals(Validation.Parameters.DependentPropertyValue,1);
			Rules = Validations.Contexts.Profile;
			assertEquals(ArrayLen(Rules),15);
			Validation = Rules[1];
			assertEquals(Validation.ValType,"required");
			assertEquals(Validation.PropertyName,"Salutation");
			assertEquals(Validation.PropertyDesc,"Salutation");
			Validation = Rules[2];
			assertEquals(Validation.ValType,"required");
			assertEquals(Validation.PropertyName,"FirstName");
			assertEquals(Validation.PropertyDesc,"First Name");
			Validation = Rules[3];
			assertEquals(Validation.ValType,"required");
			assertEquals(Validation.PropertyName,"LastName");
			assertEquals(Validation.PropertyDesc,"Last Name");
			Validation = Rules[4];
			assertEquals(Validation.ValType,"required");
			assertEquals(Validation.PropertyName,"UserName");
			assertEquals(Validation.PropertyDesc,"Email Address");
			Validation = Rules[5];
			assertEquals(Validation.ValType,"email");
			assertEquals(Validation.PropertyName,"UserName");
			assertEquals(Validation.PropertyDesc,"Email Address");
			assertEquals(Validation.FailureMessage,"Hey, buddy, you call that an Email Address?");
			Validation = Rules[6];
			assertEquals(Validation.ValType,"custom");
			assertEquals(Validation.PropertyName,"Nickname");
			assertEquals(Validation.PropertyDesc,"Nickname");
			assertEquals(Validation.Parameters.MethodName,"CheckDupNickname");
			Validation = Rules[7];
			assertEquals(Validation.ValType,"required");
			assertEquals(Validation.PropertyName,"UserPass");
			assertEquals(Validation.PropertyDesc,"Password");
			Validation = Rules[8];
			assertEquals(Validation.ValType,"rangelength");
			assertEquals(Validation.PropertyName,"UserPass");
			assertEquals(Validation.PropertyDesc,"Password");
			assertEquals(Validation.Parameters.MinLength,5);
			assertEquals(Validation.Parameters.MaxLength,10);
			Validation = Rules[9];
			assertEquals(Validation.ValType,"required");
			assertEquals(Validation.PropertyName,"VerifyPassword");
			assertEquals(Validation.PropertyDesc,"Verify Password");
			Validation = Rules[10];
			assertEquals(Validation.ValType,"equalTo");
			assertEquals(Validation.PropertyName,"VerifyPassword");
			assertEquals(Validation.PropertyDesc,"Verify Password");
			assertEquals(Validation.Parameters.ComparePropertyName,"UserPass");
			assertEquals(Validation.Parameters.ComparePropertyDesc,"Password");
			Validation = Rules[11];
			assertEquals(Validation.ValType,"required");
			assertEquals(Validation.PropertyName,"UserGroup");
			assertEquals(Validation.PropertyDesc,"User Group");
			Validation = Rules[12];
			assertEquals(Validation.ValType,"regex");
			assertEquals(Validation.PropertyName,"Salutation");
			assertEquals(Validation.PropertyDesc,"Salutation");
			assertEquals(Validation.Parameters.Regex,"^(Dr|Prof|Mr|Mrs|Ms|Miss)(\.)?$");
			assertEquals(Validation.FailureMessage,"Only Dr, Prof, Mr, Mrs, Ms, or Miss (with or without a period) are allowed.");
			Validation = Rules[13];
			assertEquals(Validation.ValType,"required");
			assertEquals(Validation.PropertyName,"LikeOther");
			assertEquals(Validation.PropertyDesc,"What do you like?");
			assertEquals(Validation.FailureMessage,"If you don't like Cheese and you don't like Chocolate, you must like something!");
			assertEquals(Validation.Condition.ClientTest,"$(""[name='LikeCheese']"").getValue() == 0 && $(""[name='LikeChocolate']"").getValue() == 0;");
			assertEquals(Validation.Condition.ServerTest,"getLikeCheese() EQ 0 AND getLikeChocolate() EQ 0");
			Validation = Rules[14];
			assertEquals(Validation.ValType,"numeric");
			assertEquals(Validation.PropertyName,"HowMuch");
			assertEquals(Validation.PropertyDesc,"How much money would you like?");
			Validation = Rules[15];
			assertEquals(Validation.ValType,"required");
			assertEquals(Validation.PropertyName,"CommunicationMethod");
			assertEquals(Validation.PropertyDesc,"Communication Method");
			assertEquals(Validation.Parameters.DependentPropertyDesc,"Allow Communication");
			assertEquals(Validation.Parameters.DependentPropertyName,"AllowCommunication");
			assertEquals(Validation.Parameters.DependentPropertyValue,1);
		</cfscript>  
	</cffunction>

	<cffunction name="isPropertiesStructCorrect" access="private" returntype="void">
		<cfargument type="Any" name="PropertyDescs" required="true" />
		<cfscript>
			assertEquals(StructCount(arguments.PropertyDescs),10);
			assertEquals(arguments.PropertyDescs.AllowCommunication,"Allow Communication");
			assertEquals(arguments.PropertyDescs.CommunicationMethod,"Communication Method");
			assertEquals(arguments.PropertyDescs.FirstName,"First Name");
			assertEquals(arguments.PropertyDescs.HowMuch,"How much money would you like?");
			assertEquals(arguments.PropertyDescs.LastName,"Last Name");
			assertEquals(arguments.PropertyDescs.LikeOther,"What do you like?");
			assertEquals(arguments.PropertyDescs.UserGroup,"User Group");
			assertEquals(arguments.PropertyDescs.UserName,"Email Address");
			assertEquals(arguments.PropertyDescs.UserPass,"Password");
			assertEquals(arguments.PropertyDescs.VerifyPassword,"Verify Password");
		</cfscript>  
	</cffunction>


</cfcomponent>

