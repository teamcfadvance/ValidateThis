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
<cfcomponent displayname="ServerValidator" output="false" hint="I orchestrate server side validations.">

	<cffunction name="init" access="Public" returntype="any" output="false" hint="I build a new ServerValidator">
		<cfargument name="FileSystem" type="any" required="true" />
		<cfargument name="TransientFactory" type="any" required="true" />
		<cfargument name="ObjectChecker" type="any" required="true" />
		<cfargument name="ExtraRuleValidatorComponentPaths" type="any" required="true" />
		
		<cfset variables.FileSystem = arguments.FileSystem />
		<cfset variables.TransientFactory = arguments.TransientFactory />
		<cfset variables.ObjectChecker = arguments.ObjectChecker />
		<cfset variables.ExtraRuleValidatorComponentPaths = arguments.ExtraRuleValidatorComponentPaths />
		<cfset variables.RuleValidators = {} />

		<cfset setRuleValidators() />
		<cfif len(variables.ExtraRuleValidatorComponentPaths) gt 0>
			<cfset setRuleValidators(variables.ExtraRuleValidatorComponentPaths)/>
		</cfif>
				
		<cfreturn this />
	</cffunction>

	<cffunction name="validate" returntype="void" access="public" output="false" hint="I perform the validation returning info in the result object.">
		<cfargument name="BOValidator" type="any" required="true" />
		<cfargument name="theObject" type="any" required="true" />
		<cfargument name="Context" type="any" required="true" />
		<cfargument name="Result" type="any" required="true" />

		<cfset var v = "" />
		<cfset var theFailure = 0 />
		<cfset var FailureMessage = 0 />
		<cfset var Validations = arguments.BOValidator.getValidations(arguments.Context) />
		<cfset var theVal = variables.TransientFactory.newValidation(arguments.theObject) />
		<cfset var dependentPropertyExpression = 0 />
		<cfset var dependentPropertyValue = "" />
		<cfset var conditionPasses = true />
		
		<cfif IsArray(Validations) and ArrayLen(Validations)>
			<!--- Loop through the validations array, creating validation objects and using them --->
			<cfloop Array="#Validations#" index="v">
				<cfset conditionPasses = true />
				<!--- Deal with various conditions --->
				<cfif StructKeyExists(v.Condition,"ServerTest")>
					<cfset conditionPasses = arguments.theObject.testCondition(v.Condition.ServerTest) />
				<cfelseif StructKeyExists(v.Parameters,"DependentPropertyName")>
					<cfset dependentPropertyExpression = variables.ObjectChecker.findGetter(arguments.theObject,v.Parameters.DependentPropertyName) />
					<cfset dependentPropertyValue = evaluate("arguments.theObject.#dependentPropertyExpression#") />
					<cfif StructKeyExists(v.Parameters,"DependentPropertyValue")>
						<cfset conditionPasses = dependentPropertyValue EQ v.Parameters.DependentPropertyValue />
					<cfelse>
						<cfset conditionPasses = len(dependentPropertyValue) GT 0 />
					</cfif>
				</cfif>
				<cfif conditionPasses>
					<cfset theVal.load(v) />
					<cfset variables.RuleValidators[v.ValType].validate(theVal) />
					<cfif NOT theVal.getIsSuccess()>
						<cfset arguments.Result.setIsSuccess(false) />
						<cfif StructKeyExists(v,"FailureMessage") AND Len(v.FailureMessage)>
							<cfset FailureMessage = v.FailureMessage />
						<cfelse>
							<cfset FailureMessage = theVal.getFailureMessage() />
						</cfif>
						<cfset theFailure = StructNew() />
						<cfset theFailure.PropertyName = v.PropertyName />
						<cfset theFailure.ClientFieldName = v.ClientFieldName />
						<cfset theFailure.Type = v.ValType />
						<cfset theFailure.Message = FailureMessage />
						<cfset arguments.Result.addFailure(theFailure) />
					</cfif>
				</cfif>
			</cfloop>
		</cfif>
	</cffunction>

	<cffunction name="getRuleValidators" access="public" output="false" returntype="any">
		<cfreturn variables.RuleValidators />
	</cffunction>

	<cffunction name="setRuleValidators" returntype="void" access="public" output="false" hint="I create rule validator objects from a list of component paths">
		<cfargument name="ValidatorsPaths" type="string" required="false" default="#GetDirectoryFromPath(GetCurrentTemplatePath())#" hint="A comma delimited list of component paths" />
		<cfset var RSNames = "" />
		<cfset var RS = 0 />
		<cfset var ValidatorsPath = ""/>
		<cfset var RulesDestination = ""/>
		<cfset var ComponentPath = ""/>
		
		<cfloop list="#arguments.ValidatorsPaths#" index="ValidatorsPath">
			<cfset RulesDestination = ValidatorsPath />
			<cfif RulesDestination neq GetDirectoryFromPath(GetCurrentTemplatePath())>
				<cfset RulesDestination = variables.FileSystem.getMappingPath(ValidatorsPath)/>
				<cfset ComponentPath = ValidatorsPath & "."/>
			</cfif>
			<cfset RSNames = variables.FileSystem.listFiles(RulesDestination)/>
			<cfloop list="#RSNames#" index="RS">
				<cfif ListLast(RS,".") EQ "cfc" AND RS CONTAINS "ServerRuleValidator_">
					<cfset variables.RuleValidators[replaceNoCase(ListLast(RS,"_"),".cfc","")] = CreateObject("component",ComponentPath & ReplaceNoCase(RS,".cfc","")).init(variables.ObjectChecker) />
				</cfif>
			</cfloop>
		</cfloop>
	</cffunction>
	
	<cffunction name="getRuleValidator" access="public" output="false" returntype="any">
		<cfargument name="RuleType" type="any" required="true" />
		<cfreturn variables.RuleValidators[arguments.RuleType] />
	</cffunction>

</cfcomponent>

