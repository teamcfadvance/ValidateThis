<!---
	
filename:		\VTDemo\UnitTests\UserServiceTest.cfc
date created:	2008-10-22
author:			Bob Silverberg (http://www.silverwareconsulting.com/)
purpose:		I UserServiceTest.cfc
				
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
<cfcomponent displayname="UnitTests.UserServiceTest" extends="UnitTests.BaseTestCase" output="false">
	
	<cfset Transfer = "" />
	<cfset UserTO = "" />
	<cfset UserService = "" />

	<cffunction name="setUp" access="public" returntype="void">
		<cfset setBeanFactory()>
		<cfset Transfer = getBeanFactory().getBean("Transfer") />
		<cfset UserService = getBeanFactory().getBean("UserService") />
	</cffunction>
	
	<cffunction name="tearDown" access="public" returntype="void">
	</cffunction>
	
	<cffunction name="setUpUser" access="private" returntype="void">
		<cfargument name="UserGroupDesc" type="any" required="false" default="Member" />
		<cfscript>
			UserTO = Transfer.new("user.user");
			UserTO.wrapMe();
			UserTO.setUserName(Right(CreateUUID(),1) & "@test.com");
			UserTO.setNickname(UserTO.getUserName());
			UserTO.setUserPass(UserTO.getUserName());
			UserTO.setVerifyPassword(UserTO.getUserName());
			UserTO.setUserGroup(Transfer.readByProperty("user.usergroup", "UserGroupDesc", arguments.UserGroupDesc));
			UserTO.setLikeOther("Steak");
			Result = UserTO.save();
		</cfscript>
	</cffunction>

	<cffunction name="tearDownUser" access="private" returntype="void">
		<cfscript>
			UserTO.delete();
		</cfscript>
	</cffunction>

	<cffunction name="getExistingUserReturnsUser" access="public" returntype="void">
		<cfscript>
			setUpUser();
			//debug(getMetaData(UserTO));
			objUser = UserService.getUser(UserTO.getUserId());
			debug(objUser.getMemento());
			AssertEquals(objUser.getUserId(),UserTO.getUserId());
			AssertTrue(objUser.getIsPersisted());
			tearDownUser();
		</cfscript>
	</cffunction>

	<cffunction name="getNonExistingUserReturnsNewUser" access="public" returntype="void">
		<cfscript>
			objUser = UserService.getUser(0);
			AssertEquals(objUser.getUserId(),0);
			AssertFalse(objUser.getIsPersisted());
		</cfscript>
	</cffunction>

	<cffunction name="updateUserReturnsUpdatedUser" access="public" returntype="void">
		<cfscript>
			setUpUser();
			args = {FirstName="Bob",VerifyPassword=UserTO.getUserPass()};
			Result = UserService.updateUser(theId=UserTO.getUserId(),args=args);
			AssertTrue(Result.getIsSuccess());
			AssertEquals(Result.getTheObject().getUserId(),UserTO.getUserId());
			AssertEquals(Result.getTheObject().getFirstName(),"Bob");
			tearDownUser();
		</cfscript>
	</cffunction>

</cfcomponent>

