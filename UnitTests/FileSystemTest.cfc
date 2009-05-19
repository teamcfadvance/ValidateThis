<!---
	
filename:		\VTDemo\UnitTests\FileSystemTest.cfc
date created:	2008-10-22
author:			Bob Silverberg (http://www.silverwareconsulting.com/)
purpose:		I FileSystemTest.cfc
				
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
<cfcomponent displayname="UnitTests.FileSystemTest" extends="UnitTests.BaseTestCase" output="false">
	
	<cfset FileSystem = "" />
	<cfset Destination = "" />
	
	<cffunction name="setUp" access="public" returntype="void">
		<cfscript>
			setBeanFactory();
			FileSystem = getBeanFactory().getBean("ValidateThis").getBean("FileSystem") ;
			Destination = GetDirectoryFromPath(GetCurrentTemplatePath());
		</cfscript>
	</cffunction>
	
	<cffunction name="tearDown" access="public" returntype="void">
	</cffunction>
	
	<cffunction name="testInit" access="public" returntype="void">
		<cfscript>
			assertTrue(isObject(FileSystem));
		</cfscript>  
	</cffunction>

	<cffunction name="testCheckFileExists" access="public" returntype="void">
		<cfscript>
			Result = FileSystem.CheckFileExists(Destination,ListLast(GetCurrentTemplatePath(),"\"));
			assertTrue(Result);
			Result = FileSystem.CheckFileExists(Destination,ListLast(GetCurrentTemplatePath(),"\")&"notafile");
			assertFalse(Result);
		</cfscript>  
	</cffunction>

	<cffunction name="testCreateFileReadDelete" access="public" returntype="void">
		<cfscript>
			FileName = CreateUUID() & ".txt";
			Content = "The file content.";
			Result = FileSystem.CheckFileExists(Destination,FileName);
			assertFalse(Result);
			Result = FileSystem.CreateFile(Destination,FileName,Content);
			assertTrue(Result.getIsSuccess());
			Result = FileSystem.CheckFileExists(Destination,FileName);
			assertTrue(Result);
			Result = FileSystem.Read(Destination,FileName);
			assertTrue(Result.getIsSuccess());
			assertEquals(Trim(Result.getContent()),Content);
			Result = FileSystem.Delete(Destination,FileName);
			assertTrue(Result.getIsSuccess());
			Result = FileSystem.CheckFileExists(Destination,FileName);
			assertFalse(Result);
		</cfscript>  
	</cffunction>

</cfcomponent>

