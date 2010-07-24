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
/**
* @persistent true
* @table tblUser_A
* @vtContexts [{"name":"Register","formName":"frmRegister"},{"name":"Profile","formName":"frmProfile"}]
* @vtConditions [{"name":"MustLikeSomething", 
		"serverTest":"getLikeCheese() EQ 0 AND getLikeChocolate() EQ 0",
		"clientTest":"$(&quot;[name='LikeCheese']&quot;).getValue() == 0 && $(&quot;[name='LikeChocolate']&quot;).getValue() == 0;"}]
*/
component {
	
	/**
	* @fieldtype id
	* @generator native
	*/
	property numeric UserId;
	
	/**
	* @vtDesc Email Address
	* @vtRules [
			{"type":"required","contexts":"*"},
			{"type":"email","failureMessage":"Hey, buddy, you call that an Email Address?"}
		]
	*/
	property string UserName;

	/**
	* @displayName Password
	* @vtRules [
			{"type":"required"},
			{"type":"rangelength",
				"params" : [
					{"minlength":"5"},
					{"maxlength":"10"}
				]
			}
		]
	*/
	property string UserPass;
	
	/**
	* @vtRules [
			{"type":"custom","failureMessage":"That Nickname is already taken. Please try another",
				"params":[
					{"methodName":"CheckDupNickname"},
					{"remoteURL":"CheckDupNickname.cfm"}
				]}
		]
	*/
	property string Nickname;
	
	/**
	* @vtRules [
			{"type":"required","contexts":"Profile"},
			{"type":"regex","failureMessage":"Only Dr, Prof, Mr, Mrs, Ms, or Miss (with or without a period) are allowed.",
				"params" : [
					{"Regex":"^(Dr|Prof|Mr|Mrs|Ms|Miss)(\\.)?$"}
				]
			}
		]
	*/
	property string Salutation;
	
	/**
	* @vtRules [
			{"type":"required","contexts":"Profile"}
		]
	*/
	property string FirstName;
	
	/**
	* @vtRules [
			{"type":"required","contexts":"Profile"},
			{"type":"required","contexts":"Register",
				"params" : [
					{"DependentPropertyName":"FirstName"}
				]
			}
		]
	*/
	property string LastName;
	
	/**
	* @ormtype int
	* @default 1
	*/
	property string LikeCheese;
	
	/**
	* @ormtype int
	* @default 1
	*/
	property string LikeChocolate;
	
	/**
	* @displayName What do you like?
	* @vtRules [
			{"type":"required","condition":"MustLikeSomething","failureMessage":"If you don't like cheese and you don't like chocolate, you must like something!"}
		]
	*/
	property string LikeOther;
	
	/**
	* @ormtype timestamp
	*/
	property string LastUpdateTimestamp;
	
	/**
	* @ormtype int
	*/
	property string AllowCommunication;
	
	/**
	* ormtype int
	* @displayName How much money would you like?
	* @vtRules [
			{"type":"numeric"}
		]
	*/
	property string HowMuch;
	
	/**
	* @vtRules [
			{"type":"required","failureMessage":"if you are allowing communication, you must choose a method",
				"params" : [
					{"DependentPropertyName":"AllowCommunication"},
					{"DependentPropertyValue":"1"}
				]
			}
		]
	*/
	property string CommunicationMethod;
	
	/**
	* @fieldtype many-to-one
	* @cfc UserGroup
	* @fkcolumn UserGroupId
	* @vtClientFieldName UserGroupId
	* @vtRules [
			{"type":"required"}
		]
	*/
	property string UserGroup;
	
		/**
	* @persistent false
	* @vtRules [
			{"type":"required"},
			{"type":"equalTo",
				"params" : [
					{"ComparePropertyName":"UserPass"}
				]
			}
		]
	*/
	property string verifyPassword;
	
	public struct function checkDupNickname() {
		// This is just a "mock" method to test out the custom validation type
		var returnStruct = {isSuccess = false, failureMessage = "That Nickname has already been used. Try to be more original!"};
		if (getNickname() NEQ "BobRules") {
			returnStruct = {isSuccess = true};
		}
		return returnStruct;		
	}
	
	public void function setUserGroupId(userGroupId) hint="used to populate the UserGroup from the form" {
		var userGroup = entityLoadByPK("UserGroup",val(arguments.userGroupId));
		if (not isNull(userGroup)) {
			variables.UserGroup = userGroup;
		}
	}
	
	public boolean function testCondition(string condition) {
		return evaluate(arguments.condition);
	}

}
