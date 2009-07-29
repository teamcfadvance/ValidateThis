<cfcomponent name="ValidateThis" hint="This is a coldbox plugin for ValidateThis" extends="coldbox.system.plugin" cache="false">

  <!------------------------------------------- CONSTRUCTOR ------------------------------------------->

  <cffunction name="init" access="public" returntype="ValidateThis" output="false">
		<cfargument name="controller" type="any" required="true">
		<cfset super.Init(arguments.controller) />
		<cfset setpluginName("ValidateThis! Plugin")>
		<cfset setpluginVersion("1.0")>
		<cfset setpluginDescription("A plugin for object-based validation.")>
		
		<!--- My Custom Constructor code goes here --->
		<!--- <cfset variables.ValidateThisConfig = arguments.ValidateThisConfig /> --->
		<cfset variables.ValidateThisConfig = StructNew()>
		
		<!--- Set default values for keys in ValidateThisConfig --->
		<cfparam name="variables.ValidateThisConfig.TranslatorPath" default="ValidateThis.core.BaseTranslator" />
		<cfparam name="variables.ValidateThisConfig.BOValidatorPath" default="model.Validator" />
		<cfparam name="variables.ValidateThisConfig.DefaultJSLib" default="jQuery" />
		<cfparam name="variables.ValidateThisConfig.JSRoot" default="js/" />
		<cfparam name="variables.ValidateThisConfig.defaultFormName" default="frmMain" />
		<cfparam name="variables.ValidateThisConfig.definitionPath" default="/model/" />
		<cfparam name="variables.ValidateThisConfig.localeMap" default="#StructNew()#" />
		<cfparam name="variables.ValidateThisConfig.defaultLocale" default="en_US" />

		<cfset variables.ValidationFactory = CreateObject("component","ValidateThis.core.ValidationFactory").init(variables.ValidateThisConfig) />
				
		<!--- Return instance --->
		<cfreturn this>
  </cffunction>

  <!--- All my methods go below --->
	<cffunction name="getValidator" access="public" output="false" returntype="any">
		<cfargument name="objectType" type="any" required="true" />
		<cfargument name="definitionPath" type="any" required="false" default="" />

		<cfreturn variables.ValidationFactory.getValidator(arguments.objectType,arguments.definitionPath) />
		
	</cffunction>

	
	<cffunction name="setupValidation" access="public" output="false" returntype="void" hint="Creates the default form setup for validation">
		<cfargument name="objectlist" type="string" required="true" hint="One or more objects to validate. As a list.">
		<cfargument name="context" type="string" required="true" hint="The context of the form to validate">

		<cfset var rc = getController().getRequestService().getContext().getCollection()>

		<cfscript>
			//Required JQuery Libraries
			rc.scriptInclude.addResource(file='jquery.field.min',type='JS',path='');
			rc.scriptInclude.addResource(file='jquery.validate',type='JS',path='');
			//Init the ValidateThis
			rc.scriptInclude.addScript(script=getMyPlugin('ValidateThis').getInitializationScript());
			
			//Default form jquery init
			rc.scriptInclude.addResource(type='JS',path='',file='forms');		
		</cfscript>

		<cfloop index="object" list="#arguments.objectlist#">		
			<cfset rc.scriptInclude.addScript(script=getMyPlugin('ValidateThis').getValidationScript(objectType='#object#',Context='#arguments.context#'))>
		</cfloop>
	
	</cffunction>
	
 	<cffunction name="getInitializationScript" returntype="any" access="public" output="false"> 

		<cfset var theScript = "" />
		
		<cfsavecontent variable="theScript">
		<script type="text/javascript">
			$(document).ready(function() {
				jQuery.validator.addMethod("regex", function(value, element, param) {
					var re = param;
					return this.optional(element) || re.test(value);
				}, jQuery.format("The value entered does not match the specified pattern ({0})"));
			});
		</script>
		</cfsavecontent>

		<cfreturn theScript />
	</cffunction>		
	
	<cffunction name="validate" access="public" output="false" returntype="any">
		<cfargument name="objectType" type="any" required="true" />
		<cfargument name="theObject" type="any" required="true" />
		<cfargument name="Context" type="any" required="false" default="" />
		<cfargument name="Result" type="any" required="false" default="" />

		<cfset var BOValidator = getValidator(arguments.objectType,"") />
		<!--- Inject testCondition if needed --->
		<cfif NOT StructKeyExists(arguments.theObject,"testCondition")>
			<cfset arguments.theObject["testCondition"] = this["testCondition"] />
		</cfif>
		<cfset arguments.Result = BOValidator.validate(arguments.theObject,arguments.Context,arguments.Result) />
		
		<cfreturn arguments.Result />

	</cffunction>
	
	<cffunction name="onMissingMethod" access="public" output="false" returntype="Any" hint="This is used to help communicate with the BOValidator, which is accessed via the ValidationFactory when needed">
		<cfargument name="missingMethodName" type="any" required="true" />
		<cfargument name="missingMethodArguments" type="any" required="true" />

		<cfset var local = {} />
		<cfset local.returnValue = "" />
		<cfset local.objectType = "" />
		
		<cfif StructKeyExists(arguments.missingMethodArguments,"objectType")>
			<cfset local.objectType = arguments.missingMethodArguments.objectType />
		<cfelseif StructKeyExists(arguments.missingMethodArguments,"theObject") AND StructKeyExists(arguments.missingMethodArguments.theObject,"getobjectType")>
			<cfinvoke component="#arguments.missingMethodArguments.theObject#" method="getobjectType" returnvariable="local.objectType" />
		</cfif>
		<cfif Len(local.objectType)>
			<cfset local.BOValidator = getValidator(local.objectType,"") />
			<cfinvoke component="#local.BOValidator#" method="#arguments.missingMethodName#" argumentcollection="#arguments.missingMethodArguments#" returnvariable="local.returnValue" />
			<cfif NOT StructKeyExists(local,"returnValue")>
				<cfset local.returnValue = "" />
			</cfif>
		</cfif>
		
		<cfreturn local.returnValue />
		
	</cffunction>

	<cffunction name="newResult" returntype="any" access="public" output="false" hint="I create a Result object.">

		<cfreturn variables.ValidationFactory.newResult() />
		
	</cffunction>

	<cffunction name="testCondition" access="Public" returntype="boolean" output="false" hint="I dynamically evaluate a condition and return true or false.">
		<cfargument name="Condition" type="any" required="true" />
		
		<cfreturn Evaluate(arguments.Condition)>

	</cffunction>

	<cffunction name="getBean" access="public" output="false" returntype="any" hint="I am used to aid Unit Testing">
		<cfargument name="BeanName" type="Any" required="false" />
		
		<cfreturn variables.ValidationFactory.getBean(arguments.BeanName) />
	
	</cffunction>
</cfcomponent>
