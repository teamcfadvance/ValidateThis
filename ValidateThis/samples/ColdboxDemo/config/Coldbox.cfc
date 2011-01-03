<cfcomponent output="false" hint="My App Configuration">
<cfscript>
// Configure ColdBox Application
function configure(){

	// coldbox directives
	coldbox = {
		//Application Setup
		appName 				= "ValidateThisDemo",
		
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
		ValidateThisConfig = {
			// I will include Javascript libraries myself
			JSIncludes=false,
			// use a customised version of ValidateThis.util.Result
			ResultPath="model.ValidationResult"
		}
	};
	
	//Register interceptors as an array, we need order
	interceptors = [
		//Autowire
		{
			class="coldbox.system.interceptors.Autowire"
		}
	];	
}
	
</cfscript>
</cfcomponent>