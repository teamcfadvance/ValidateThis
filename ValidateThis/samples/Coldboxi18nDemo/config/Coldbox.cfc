<!---

	Copyright 2011, Bob Silverberg & John Whish
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.

--->
<cfcomponent output="false" hint="My App Configuration">
<cfscript>
// Configure ColdBox Application
function configure(){

	// coldbox directives
	coldbox = {
		//Application Setup
		appName 				= "ValidateThisi18nDemo",
		
		//Development Settings
		debugMode				= false,
		debugPassword			= "",
		reinitPassword			= "",
		handlersIndexAutoReload = true,
		configAutoReload		= false,
		
		//Implicit Events
		defaultEvent			= "general.index",
		requestStartHandler		= "main.requeststart",
		requestEndHandler		= "",
		applicationStartHandler = "",
		applicationEndHandler	= "",
		sessionStartHandler 	= "",
		sessionEndHandler		= "",
		missingTemplateHandler	= "",
		
		//Error/Exception Handling
		exceptionHandler		= "",
		onInvalidEvent			= "",
		customErrorTemplate		= "",
			
		//Application Aspects
		handlerCaching 			= false,
		eventCaching			= true
	};
	
	//Layout Settings
	layoutSettings = {
		defaultLayout = "Layout.Main.cfm"
	};
	
	// custom settings
	settings = {
	};
	
	//i18n & Localisation
	i18n = {
		defaultResourceBundle = "includes/i18n/main",
		defaultLocale = "en_GB",
		localeStorage = "cookie"
	};
	
	//Register interceptors as an array, we need order
	interceptors = [
		//Autowire
		{
			class="coldbox.system.interceptors.Autowire"
		},
		//ValidateThis
		{
			class="validatethis.extras.coldbox.ColdBoxValidateThisInterceptor",
			properties = {
				// Tell VT that I want to use a customised version of ValidateThis.util.Result (optional)
				ResultPath="model.ValidationResult",
				// Tell VT that I want to use a customised version of ValidateThis.core.BOValidator (optional)
				boValidatorPath="model.BOValidator"
			}
		}
	];
}
	
</cfscript>
</cfcomponent>