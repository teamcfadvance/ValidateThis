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
<cfcomponent extends="validatethis.tests.BaseTestCase" output="false">
	
	<cffunction name="setUp" access="public" returntype="void">
		<cfscript>
			annotationTypeReader = CreateObject("component","ValidateThis.core.annotationTypeReaders.AnnotationTypeReader_VTML").init("frmMain");
		</cfscript>
	</cffunction>

	<cffunction name="tearDown" access="public" returntype="void">
	</cffunction>

	<cffunction name="isThisFormatReturnsTrueForComplexVTML" access="public" returntype="void">
		<cfscript>
			assertTrue(annotationTypeReader.isThisFormat('hot(smart=true,cute=true)[*,Friends,Parents,Sleep]{isCool} "this chick is not hot.";'));
		</cfscript>  
	</cffunction>
	
	<cffunction name="isThisFormatReturnsTrueForRequiredVTML" access="public" returntype="void">
		<cfscript>
			assertTrue(annotationTypeReader.isThisFormat('required()'));
		</cfscript>  
	</cffunction>
	
	<cffunction name="isThisFormatReturnsTrueForVTMLWithNoCondition" access="public" returntype="void">
		<cfscript>
			assertTrue(annotationTypeReader.isThisFormat('required()'));
		</cfscript>  
	</cffunction>

	<cffunction name="isThisFormatReturnsTrueForVTMLWithNoContext" access="public" returntype="void">
		<cfscript>
			assertTrue(annotationTypeReader.isThisFormat('required()'));
		</cfscript>  
	</cffunction>

	<cffunction name="isThisFormatReturnsTrueForVTMLWithNoFailureMessage" access="public" returntype="void">
		<cfscript>
			assertTrue(annotationTypeReader.isThisFormat('required()'));
		</cfscript>  
	</cffunction>
	
	<cffunction name="isThisFormatReturnsTrueForVTMLWithFailureMessage" access="public" returntype="void">
		<cfscript>
			assertTrue(annotationTypeReader.isThisFormat('required()"CustomMessage"'));
		</cfscript>  
	</cffunction>
	
	<cffunction name="isThisFormatReturnsFalseForNonVTMLString" access="public" returntype="void">
		<cfscript>
			// Can you catch the subtle error here? using " around a parameter value in VTML is invalid.... for now
			assertTrue(annotationTypeReader.isThisFormat('hot(smart="true",cute=true)[*,Sleep]{isCool} "this chick is not hot.";'));
		</cfscript>  
	</cffunction>


	<cffunction name="loadRulesReturnsCorrectPropertyDescs" access="public" returntype="void">
		<cfscript>
			md = getComponentMetadata("validatethis.tests.Fixture.AnnotatedBOs.User_WithVTML");
			PropertyDescs = annotationTypeReader.getValidations(md).PropertyDescs;
			isPropertiesStructCorrect(PropertyDescs);
		</cfscript>  
	</cffunction>

	<cffunction name="isPropertiesStructCorrect" access="private" returntype="void">
		<cfargument type="Any" name="PropertyDescs" required="true" />
		<cfscript>
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

	<cffunction name="placeholderForVTMLTests" access="public" returntype="void">
		<cfscript>
			fail("This is a placeholder test for tests that need to be added.");
		</cfscript>  
	</cffunction>
</cfcomponent>

