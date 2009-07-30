<!---
	
	Copyright 2008, Bob Silverberg
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
--->
<cfcomponent output="false" name="BOValidator" hint="I am a validator responsible for holding validation rules for a business object.">

	<cffunction name="init" returnType="any" access="public" output="false" hint="I build a new BOValidator">
		<cfargument name="objectType" type="any" required="true" />
		<cfargument name="FileSystem" type="any" required="true" />
		<cfargument name="XMLFileReader" type="any" required="true" />
		<cfargument name="ServerValidator" type="any" required="true" />
		<cfargument name="ClientValidator" type="any" required="true" />
		<cfargument name="TransientFactory" type="any" required="true" />
		<cfargument name="onMMHelper" type="any" required="true" />
		<cfargument name="ValidateThisConfig" type="any" required="true" />
		<cfargument name="definitionPath" type="any" required="true" />
		<cfargument name="CommonScriptGenerator" type="any" required="true" />

		<cfset variables.Instance = {objectType = arguments.objectType} />
		<cfset variables.Instance.newRules = {} />
		<cfset variables.FileSystem = arguments.FileSystem />
		<cfset variables.XMLFileReader = arguments.XMLFileReader />
		<cfset variables.ServerValidator = arguments.ServerValidator />
		<cfset variables.ClientValidator = arguments.ClientValidator />
		<cfset variables.TransientFactory = arguments.TransientFactory />
		<cfset variables.onMMHelper = arguments.onMMHelper />
		<cfset variables.ValidateThisConfig = arguments.ValidateThisConfig />
		<cfset variables.CommonScriptGenerator = arguments.CommonScriptGenerator />
		
		<!--- If the definitionPath passed in is empty, get it from the ValidateThisConfig --->
		<cfif NOT Len(arguments.definitionPath)>
			<cfset arguments.definitionPath = arguments.ValidateThisConfig.definitionPath />
		</cfif>
		
		<cfset processXML(arguments.objectType,arguments.definitionPath) />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="processXML" returnType="void" access="private" output="false" hint="I ask the XMLFileReader to read the validations XML file and reformat it into a struct">
		<cfargument name="objectType" type="any" required="true" />
		<cfargument name="definitionPath" type="any" required="true" />

		<cfset var theStruct = variables.XMLFileReader.processXML(arguments.objectType,arguments.definitionPath) />

		<cfset variables.Instance.PropertyDescs = theStruct.PropertyDescs />
		<cfset variables.Instance.ClientFieldDescs = theStruct.ClientFieldDescs />
		<cfset variables.Instance.FormContexts = theStruct.FormContexts />
		<cfset variables.Instance.Validations = theStruct.Validations />
		
	</cffunction>

	<cffunction name="addRule" returnType="void" access="public" output="false" hint="I am used to add a rule via CF code">
		<cfargument name="propertyName" type="any" required="true" />
		<cfargument name="valType" type="any" required="true" />
		<cfargument name="clientFieldName" type="any" required="false" default="#arguments.propertyName#" />
		<cfargument name="propertyDesc" type="any" required="false" default="" />
		<cfargument name="condition" type="Struct" required="false" default="#StructNew()#" />
		<cfargument name="parameters" type="Struct" required="false" default="#StructNew()#" />
		<cfargument name="contexts" type="any" required="false" default="" />
		<cfargument name="failureMessage" type="any" required="false" default="" />
		<cfargument name="formName" type="any" required="false" default="" />

		<cfset var theRule = Duplicate(arguments) />
		<cfset var theContext = 0 />
		<cfset var ruleHash = getHashFromStruct(theRule) />
		
		<cfif NOT StructKeyExists(variables.Instance.newRules,ruleHash)>
			<cflock name="#ruleHash#" type="exclusive" timeout="10" throwontimeout="true">
				<cfif NOT StructKeyExists(variables.Instance.newRules,ruleHash)>
					<cfset variables.Instance.newRules[ruleHash] = 1 />
					<cfif Len(theRule.propertyDesc)>
						<cfif NOT StructKeyExists(variables.Instance.PropertyDescs,theRule.propertyName)>
							<cfset variables.Instance.PropertyDescs[theRule.propertyName] = theRule.propertyDesc />
						</cfif>
					<cfelseif StructKeyExists(variables.Instance.PropertyDescs,theRule.propertyName)>
						<cfset theRule.propertyDesc = variables.Instance.PropertyDescs[theRule.propertyName] />
					<cfelse>
						<cfset theRule.propertyDesc = theRule.propertyName />
					</cfif>
					<cfif NOT StructKeyExists(variables.Instance.ClientFieldDescs,theRule.clientFieldName)>
						<cfset variables.Instance.ClientFieldDescs[theRule.clientFieldName] = theRule.propertyDesc />
					</cfif>
					<cfif Len(theRule.contexts) AND NOT ListFindNoCase(theRule.contexts,"*")>
						<cfloop list="#theRule.contexts#" index="theContext">
							<cfif NOT StructKeyExists(variables.Instance.Validations.Contexts,theContext)>
								<cfset variables.Instance.Validations.Contexts[theContext] = ArrayNew(1) />
							</cfif>
							<cfset ArrayAppend(variables.Instance.Validations.Contexts[theContext],theRule) />
							<cfif NOT StructKeyExists(variables.Instance.FormContexts,theContext) AND Len(arguments.formName)>
								<cfset variables.Instance.FormContexts[theContext] = arguments.formName />
							</cfif>
						</cfloop>
					<cfelse>
						<cfloop collection="#variables.Instance.Validations.Contexts#" item="theContext">
							<cfset ArrayAppend(variables.Instance.Validations.Contexts[theContext],theRule) />
						</cfloop>
					</cfif>
				</cfif>
			</cflock>
		</cfif>		

	</cffunction>

	<cffunction name="newResult" returntype="any" access="public" output="false" hint="I create a Result object.">

		<cfreturn variables.TransientFactory.newResult() />
		
	</cffunction>

	<cffunction name="newBusinessObjectWrapper" returntype="any" access="public" output="false" hint="I create a BusinessObjectWrapper object.">
		<cfargument name="theObject" type="any" required="yes" />

		<cfreturn variables.TransientFactory.newBusinessObjectWrapper(arguments.theObject,variables.onMMHelper) />
		
	</cffunction>
	
	<cffunction name="validate" returntype="any" access="public" output="false" 
		hint="I perform the validations using the Server Validator, returning info in the result object.">
		<cfargument name="theObject" type="any" required="true" />
		<cfargument name="Context" type="any" required="false" default="" />
		<cfargument name="Result" type="any" required="false" default="" />

		<cfif IsSimpleValue(arguments.Result)>
			<cfset arguments.Result = newResult() />
		</cfif>
		<!--- Put the object into the result so it can be retrieved from there --->
		<cfset arguments.Result.setTheObject(arguments.theObject) />
		<cfset variables.ServerValidator.validate(this,arguments.theObject,arguments.Context,arguments.Result) />
		<cfreturn arguments.Result />
		
	</cffunction>

	<cffunction name="getValidationScript" returntype="any" access="public" output="false" 
		hint="I generate the JS using the Client Validator script.">
		<cfargument name="Context" type="any" required="false" default="" />
		<cfargument name="formName" type="any" required="false" default="#getFormName(arguments.Context)#" hint="The name of the form for which validations are being generated." />
		<cfargument name="JSLib" type="any" required="false" default="#variables.ValidateThisConfig.defaultJSLib#" />
		<cfargument name="locale" type="Any" required="no" default="" />

		<cfreturn variables.ClientValidator.getValidationScript(getValidations(arguments.Context),arguments.formName,arguments.JSLib,arguments.locale) />

	</cffunction>

	<cffunction name="getInitializationScript" returntype="any" access="public" output="false" hint="I generate JS statements required to setup client-side validations for VT.">
		<cfargument name="JSLib" type="any" required="true" />
		<cfargument name="JSIncludes" type="Any" required="no" default="true" />
		<cfargument name="locale" type="Any" required="no" default="" />

		<cfreturn variables.CommonScriptGenerator.getInitializationScript(argumentCollection=arguments) />

	</cffunction>

	<cffunction name="getValidations" access="public" output="false" returntype="any">
		<cfargument name="Context" type="any" required="false" default="" />
		
		<cfset var theContext = fixDefaultContext(arguments.Context) />
		
		<cfreturn variables.Instance.Validations.Contexts[theContext] />
	</cffunction>

	<cffunction name="getFormName" access="public" output="false" returntype="any">
		<cfargument name="Context" type="any" required="true" />
		
		<cfset var theContext = fixDefaultContext(arguments.Context) />
		<cfset var formName = variables.ValidateThisConfig.defaultFormName />
		<cfif StructKeyExists(variables.Instance.FormContexts,theContext)>
			<cfset formName = variables.Instance.FormContexts[theContext] />
		</cfif>
		<cfreturn formName />
	</cffunction>

	<cffunction name="getValidationPropertyDescs" access="public" output="false" returntype="any">
		<cfreturn variables.Instance.PropertyDescs />
	</cffunction>
	
	<cffunction name="getValidationClientFieldDescs" access="public" output="false" returntype="any">
		<cfreturn variables.Instance.ClientFieldDescs />
	</cffunction>
	
	<cffunction name="getValidationFormContexts" access="public" output="false" returntype="any">
		<cfreturn variables.Instance.FormContexts />
	</cffunction>
	
	<cffunction name="getRequiredProperties" access="public" output="false" returntype="any">
		<cfargument name="Context" type="any" required="false" default="" />
		
		<cfset var theContext = fixDefaultContext(arguments.Context) />
		<cfset var validation = 0 />
		<cfset var FieldList = StructNew() />
		<cfloop array="#variables.Instance.Validations.Contexts[theContext]#" index="validation">
			<cfif validation.ValType EQ "required" AND StructIsEmpty(validation.Parameters) AND StructIsEmpty(validation.Condition)>
				<cfset FieldList[validation.PropertyName] = "required" />
			</cfif>
		</cfloop>
		<cfreturn FieldList />
	</cffunction>
	
	<cffunction name="getRequiredFields" access="public" output="false" returntype="any">
		<cfargument name="Context" type="any" required="false" default="" />
		
		<cfset var theContext = fixDefaultContext(arguments.Context) />
		<cfset var validation = 0 />
		<cfset var FieldList = StructNew() />
		<cfloop array="#variables.Instance.Validations.Contexts[theContext]#" index="validation">
			<cfif validation.ValType EQ "required" AND StructIsEmpty(validation.Parameters) AND StructIsEmpty(validation.Condition)>
				<cfset FieldList[validation.ClientFieldName] = "required" />
			</cfif>
		</cfloop>
		<cfreturn FieldList />
	</cffunction>
	
	<cffunction name="getAllContexts" access="public" output="false" returntype="any">
		
		<cfreturn variables.Instance.Validations.Contexts />
	</cffunction>
	
	<cffunction name="fixDefaultContext" access="public" output="false" returntype="any">
		<cfargument name="Context" type="any" required="true" />
		<cfif NOT Len(arguments.Context) OR arguments.Context EQ "*" OR NOT StructKeyExists(variables.Instance.Validations.Contexts,arguments.Context)>
			<cfreturn "___Default" />
		<cfelse>
			<cfreturn arguments.Context />
		</cfif>
	</cffunction>
	
	<cffunction name="getHashFromStruct" access="public" output="false" returntype="any">
		<cfargument name="args" type="struct" required="true" />

		<cfset var arg = 0 />
		<cfset var argList = "" />

		<cfloop list="#ListSort(StructKeyList(arguments.args),'Text')#" index="arg">
			<cfif IsSimpleValue(arguments.args[arg])>
				<cfset argList = argList & arguments.args[arg] />
			</cfif>
		</cfloop>		

		<cfreturn Hash(argList) />
	</cffunction>
	
	<cffunction name="onMissingMethod" access="public" output="false" returntype="Any" hint="This is used to eliminate the need for duplicate methods which all just pass calls on to the Client Validator.">
		<cfargument name="missingMethodName" type="any" required="true" />
		<cfargument name="missingMethodArguments" type="any" required="true" />

		<cfset var scriptType = determineScriptType(arguments.missingMethodName) />
		<cfif Len(scriptType)>
			<cfreturn variables.ClientValidator.getGeneratedJavaScript(scriptType=scriptType,JSLib=arguments.missingMethodArguments.JSLib,formName=determineFormName(arguments.missingMethodArguments),locale=determineLocale(arguments.missingMethodArguments)) />
		<cfelse>
			<cfthrow type="ValidateThis.core.BOValidator.MethodNotDefined" detail="The method #arguments.missingMethodName# does not exist in the BOValidator object." />
		</cfif>
		
	</cffunction>
	
	<cffunction name="determineScriptType" returntype="any" access="public" output="false" hint="I try to determine the script type by looking at the missing method name.">
		<cfargument name="methodName" type="any" required="true" />

		<cfif Left(arguments.methodName,3) EQ "get" AND Right(arguments.methodName,6) EQ "Script">
			<cfreturn Mid(arguments.methodName,4,Len(arguments.methodName)-9) />
		<cfelse>
			<cfreturn "" />
		</cfif>
	</cffunction>

	<cffunction name="determineFormName" returntype="any" access="public" output="false" hint="I try to determine the form name by looking at the missing method arguments.">
		<cfargument name="theArguments" type="any" required="true" />
		
		<cfif StructKeyExists(arguments.theArguments,"formName") AND Len(arguments.theArguments.formName)>
			<cfreturn arguments.theArguments.formName />
		<cfelseif StructKeyExists(arguments.theArguments,"Context")>
			<cfreturn getFormName(arguments.theArguments.Context) />
		<cfelse>
			<cfreturn getFormName("") />
		</cfif>
	</cffunction>

	<cffunction name="determineLocale" returntype="any" access="public" output="false" hint="I try to determine the locale by looking at the missing method arguments.">
		<cfargument name="theArguments" type="any" required="true" />
		
		<cfif StructKeyExists(arguments.theArguments,"locale")>
			<cfreturn arguments.theArguments.locale />
		<cfelse>
			<cfreturn "" />
		</cfif>
	</cffunction>

</cfcomponent>
	

