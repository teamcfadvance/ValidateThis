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
<cfcomponent extends="UnitTests.BaseForServerRuleValidatorTests" output="false">
	
	<cffunction name="setUp" access="public" returntype="void">
		<cfscript>
			super.setup();
			SRV = getSRV("Custom");
			parameters = {MethodName="myMethod"};
			validation.getParameters().returns(parameters);
			theObject = mock();
		</cfscript>
	</cffunction>
	
	<cffunction name="validateReturnsFalseWhenMethodReturnsFailure" access="public" returntype="void">
		<cfscript>
			customResult = {IsSuccess=false,FailureMessage="A custom validator failed."};
			theObject.myMethod().returns(customResult);
			validation.getTheObject().returns(theObject);
			validation.getObjectValue().returns("");
			validation.getIsRequired().returns(true);
			SRV.validate(validation);
			validation.verifyTimes(1).setIsSuccess(false); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsTrueWhenMethodReturnsSuccess" access="public" returntype="void">
		<cfscript>
			customResult = {IsSuccess=true,FailureMessage=""};
			theObject.myMethod().returns(customResult);
			validation.getTheObject().returns(theObject);
			validation.getObjectValue().returns("");
			validation.getIsRequired().returns(true);
			SRV.validate(validation);
			validation.verifyTimes(0).setIsSuccess(false); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsFalseWhenMethodReturnsFalse" access="public" returntype="void">
		<cfscript>
			customResult = false;
			theObject.myMethod().returns(customResult);
			validation.getTheObject().returns(theObject);
			validation.getObjectValue().returns("");
			validation.getIsRequired().returns(true);
			validation.setFailureMessage("A custom validator failed.").returns();
			SRV.validate(validation);
			validation.verifyTimes(1).setIsSuccess(false); 
			debug(validation.debugMock());
			validation.verifyTimes(1).setFailureMessage("A custom validator failed."); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsTrueWhenMethodReturnsTrue" access="public" returntype="void">
		<cfscript>
			customResult = true;
			theObject.myMethod().returns(customResult);
			validation.getTheObject().returns(theObject);
			validation.getObjectValue().returns("");
			validation.getIsRequired().returns(true);
			SRV.validate(validation);
			validation.verifyTimes(0).setIsSuccess(false); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateGeneratesProperErrorMessageWhenOverriddenInXML" access="public" returntype="void">
		<cfscript>
			customResult = false;
			theObject.myMethod().returns(customResult);
			validation.getTheObject().returns(theObject);
			validation.getObjectValue().returns("");
			validation.getIsRequired().returns(true);
			validation.getFailureMessage().returns("A custom failure message."); 
			validation.setFailureMessage("A custom failure message.").returns();
			SRV.validate(validation);
			validation.verifyTimes(1).setIsSuccess(false); 
			debug(validation.debugMock());
			validation.verifyTimes(1).setFailureMessage("A custom failure message."); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsFalseForEmptyPropertyIfNotRequired" access="public" returntype="void">
		<cfscript>
			customResult = {IsSuccess=false,FailureMessage="A custom validator failed."};
			theObject.myMethod().returns(customResult);
			validation.getTheObject().returns(theObject);
			validation.getObjectValue().returns("");
			validation.getIsRequired().returns(false);
			SRV.validate(validation);
			validation.verifyTimes(1).setIsSuccess(false); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsFalseForEmptyPropertyIfRequired" access="public" returntype="void">
		<cfscript>
			customResult = {IsSuccess=false,FailureMessage="A custom validator failed."};
			theObject.myMethod().returns(customResult);
			validation.getTheObject().returns(theObject);
			validation.getObjectValue().returns("");
			validation.getIsRequired().returns(true);
			SRV.validate(validation);
			validation.verifyTimes(1).setIsSuccess(false); 
		</cfscript>  
	</cffunction>

	<cffunction name="validateReturnsTrueForEmptyPropertyIfNotRequired" access="public" returntype="void">
	</cffunction>
	
</cfcomponent>
