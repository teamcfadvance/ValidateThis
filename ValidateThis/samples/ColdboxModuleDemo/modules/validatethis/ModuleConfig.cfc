component {
	// Module Properties
	this.title 				= "ValidateThis";
	this.author 			= "Bob Silverberg, John Whish, Adam Drew";
	this.webURL 			= "http://www.validatethis.org";
	this.description 		= "ValidateThis ColdBox Module";
	this.version			= "1.0";
	this.entryPoint 		= "validatethis";

	function configure(){
	
		// parent settings - A structure of settings that will append and override the host application settings
		parentSettings = {};
		
		// module settings - stored in the main configuration settings struct as modules.{moduleName}.settings
		settings = {
			enabled			=	true,
			debuggingmode	=	"info",
			BOValidatorPath =   "validatethis.samples.coldboxmoduledemo.model.BOValidator",
			ResultPath 		= 	"validatethis.samples.coldboxmoduledemo.model.ValidationResult"
		};
		
		modelMappings = {
		};
		
		// SES Routes
		routes = [
			{pattern="/:handler/:action"},
			{pattern="/",handler="api",action="index"}
		];

		// Interceptor Config
		interceptorSettings = {
			customInterceptionPoints = "loadValidators,prepareValidationRequest,preValidate,validate,postValidate"
		};
		
		//Register interceptors as an array, we need order
		interceptors = [
			//ValidateThis
			{
				class="validatethis.extras.coldbox.ColdBoxValidateThisInterceptor",
				properties = {
					// ValidateThis Config
					// Tell VT that I want to use a customised version of ValidateThis.util.Result (optional)
					ResultPath=settings.ResultPath,
					// Tell VT that I want to use a customised version of ValidateThis.core.BOValidator (optional)
					boValidatorPath=settings.BOValidatorPath,
					// Turn on debugging so we can get information about which rules/conditions passed/failed (optional)
					debuggingMode="info",
					
					// Interceptor Options
					// Specify the Coldbox Cache Key
					ValidateThisCacheKey="ValidateThis",
					// Specify the Coldbox RC Key for ValidationResults
					ValidationResultKey="ValidationResult"
				}
			}
		];
	}
	
	function onLoad(){
		log.info('#this.title# loaded');
	}
	
	function preValidate(event,interceptData){
	   // intercept before validation if anything is needed
	}
	
	function postValidate(interceptData){
	   // intercept after validation if you need to do anything
	}
}