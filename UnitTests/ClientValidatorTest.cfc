<!---
	
filename:		\VTDemo\UnitTests\ClientValidatorTest.cfc
date created:	2008-10-22
author:			Bob Silverberg (http://www.silverwareconsulting.com/)
purpose:		I ClientValidatorTest.cfc
				
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
<cfcomponent displayname="UnitTests.ClientValidatorTest" extends="UnitTests.BaseTestCase" output="false">
	
	<cfset ClientValidator = "" />
	
	<cffunction name="setUp" access="public" returntype="void">
		<cfscript>
			setBeanFactory();
			Transfer = getBeanFactory().getBean("Transfer");
			ClientValidator = getBeanFactory().getBean("ValidateThis").getBean("ClientValidator");
		</cfscript>
	</cffunction>
	
	<cffunction name="tearDown" access="public" returntype="void">
	</cffunction>
	
	<!--- Too difficult to maintain!  Pieces are dealt with elsewhere 
	<cffunction name="getValidationScriptShouldReturnCorrectScript" access="public" returntype="void">
		<cfscript>
			theObject = Transfer.new("user.user");
			Script = ClientValidator.getValidationScript(theObject,"Register");
			Expected = "<script type=""text/javascript"">$(document).ready(function() {$(""##UserName"").addClass('required');$(""##UserName"").addClass('email');$(""##UserName"").addClass('custom');$(""##UserPass"").addClass('required');$(""##UserPass"").addClass('equalTo');$(""##UserPass"").addClass('rangelength');$(""##VerifyPassword"").addClass('required');$(""##MiddleInitial"").addClass('required');$(""##LikeOther"").addClass('required');});</script>";
			assertEquals(Trim(Script),Trim(Expected)); 
			theObject = Transfer.get("user.user",1);
			Script = ClientValidator.getValidationScript(theObject,"Profile");
			Expected = "<script type=""text/javascript"">$(document).ready(function() {$(""##UserName"").addClass('required');$(""##UserName"").addClass('email');$(""##UserName"").addClass('custom');$(""##UserPass"").addClass('equalTo');$(""##UserPass"").addClass('rangelength');$(""##FirstName"").addClass('required');$(""##MiddleInitial"").addClass('required');$(""##LastName"").addClass('required');$(""##LikeOther"").addClass('required');});</script>";
			assertEquals(Trim(Script),Trim(Expected));
		</cfscript>  
	</cffunction>
	--->

</cfcomponent>

