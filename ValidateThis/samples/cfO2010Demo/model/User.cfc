/*	
	Copyright 2010, Bob Silverberg
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
*/
component output="false" persistent="true" table="tblUser" {
	property name="UserId" type="numeric" fieldtype="id" generator="native";
	property name="UserName" type="string";
	property name="UserPass" type="string";
	property name="Nickname" type="string";
	property name="Salutation" type="string";
	property name="FirstName" type="string";
	property name="LastName" type="string";
	property name="LikeCheese" type="string" ormtype="int";
	property name="LikeChocolate" type="string" ormtype="int";
	property name="LikeOther" type="string";
	property name="LastUpdateTimestamp" type="string" ormtype="timestamp";
	property name="AllowCommunication" type="string" ormtype="int";
	property name="HowMuch" type="string" ormtype="int";
	property name="CommunicationMethod" type="string";
	
	property name="verifyPassword" type="string" persistent="false";
	
	public struct function checkDupNickname() {
		// This is just a "mock" method to test out the custom validation type
		var returnStruct = {isSuccess = false, failureMessage = "That Nickname has already been used. Try to be more original!"};
		if (getNickname() NEQ "BobRules") {
			returnStruct = {isSuccess = true};
		}
		return returnStruct;		
	}
	
	public boolean function testCondition(string condition) {
		return evaluate(arguments.condition);
	}

}
