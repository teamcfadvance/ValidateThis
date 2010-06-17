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
			defPath = getDirectoryFromPath(getCurrentTemplatePath()) & "Fixture/";
			BOValidator = getBeanFactory().getBean("ValidateThis").getValidator("customer",defPath);
			customer = mock();
			customResult = {IsSuccess=false,FailureMessage="A custom validator failed."};
			customer.isUsernameAvailable().returns(customResult);
		</cfscript>  
	</cffunction>

	<cffunction name="tearDown" access="public" returntype="void">
	</cffunction>

	<cffunction name="customRuleShouldAppearinAllContextsStruct" access="public" returntype="void">
		<cfscript>
			allContexts = BOValidator.getAllContexts();
			assertEquals(true,structKeyExists(allContexts,"registerInterest"));
			assertEquals("custom",allContexts.registerInterest[13].valtype);
		</cfscript>  
	</cffunction>

	<cffunction name="customRuleShouldAppearWhenAskingforRegisterInterestContext" access="public" returntype="void">
		<cfscript>
			validations = BOValidator.getValidations("registerInterest");
			assertEquals("custom",validations[13].valtype);
		</cfscript>  
	</cffunction>
	
	<cffunction name="customRuleShouldBeEnforcedWhenValidatingWithAppropriateContext" access="public" returntype="void">
		<cfscript>
			ValidationFactory = getBeanFactory().getBean("ValidateThis").getBean("ValidationFactory");
			TransientFactory = getBeanFactory().getBean("ValidateThis").getBean("TransientFactory");
			FileSystem = CreateObject("component","ValidateThis.util.FileSystem").init(TransientFactory);
			ObjectChecker = mock();
			ObjectChecker.findGetter("{*}").returns("getFirstName()");
			ExtraRuleValidatorComponentPaths = "";
			ServerValidator = CreateObject("component","ValidateThis.server.ServerValidator").init(ValidationFactory,TransientFactory,ObjectChecker,ExtraRuleValidatorComponentPaths);
			Result = TransientFactory.newResult();
			ServerValidator.validate(BOValidator,customer,"registerInterest",Result);
			failures = Result.getFailuresAsStruct();
			assertEquals("Your chosen username is required.<br />A custom validator failed.",failures.username);
		</cfscript>  
	</cffunction>
	
</cfcomponent>

