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
<cfcomponent output="false" hint="I am a responsible for reading and processing an JSON file.">

	<cffunction name="init" returnType="any" access="public" output="false" hint="I build a new XMLFileReader">
		<cfargument name="FileSystem" type="any" required="true" />
		<cfargument name="ValidateThisConfig" type="any" required="true" />

		<cfset variables.FileSystem = arguments.FileSystem />
		<cfset variables.ValidateThisConfig = arguments.ValidateThisConfig />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="processXML" returnType="any" access="public" output="false" hint="I read the validations XML file and reformat it into a struct">
		<cfargument name="objectType" type="any" required="true" />
		<cfargument name="definitionPath" type="any" required="true" />

		<cfset var ReturnStruct = {PropertyDescs = StructNew(), ClientFieldDescs = StructNew(), FormContexts = StructNew(), Validations = {Contexts = {___Default = ArrayNew(1)}}} />
		<cfset var theXML = 0 />
		<cfset var xmlConditions = 0 />
		<cfset var theConditions = {} />
		<cfset var theCondition = 0 />
		<cfset var xmlContexts = 0 />
		<cfset var theContexts = {} />
		<cfset var theContext = 0 />
		<cfset var xmlProperties = 0 />
		<cfset var theProperty = 0 />
		<cfset var theName = 0 />
		<cfset var theDesc = 0 />
		<cfset var theRules = 0 />
		<cfset var theRule = 0 />
		<cfset var theVal = 0 />
		<cfset var theParams = 0 />
		<cfset var theParam = 0 />
		<cfset var PropertyType = 0 />
		<cfset var defPath = 0 />
		<cfset var fileName = 0 />
		<cfset var aPath = 0 />
		
		<!--- Check for a valid folder in arguments.definitionPath --->		
		<cfloop list="#arguments.definitionPath#" index="aPath">
			<cfif variables.FileSystem.CheckDirectoryExists(variables.FileSystem.getAbsolutePath(aPath))>
				<cfset defPath = aPath />
				<cfbreak />
			</cfif>
		</cfloop>
		<cfif defPath EQ 0>
			<cfthrow type="ValidateThis.core.XMLFileReader.definitionPathNotFound" detail="The folder(s) #arguments.definitionPath# can not be found. You must specify either a complete path to a physical folder or a mapping to a physical folder." />
		</cfif>

		<!--- Try to locate a rules xml file --->		
		<cfloop list="#arguments.definitionPath#" index="aPath">
			<cfset defPath = variables.FileSystem.getAbsolutePath(aPath) />
			<cfif variables.FileSystem.checkFileExists(defPath,arguments.objectType & ".xml")>
				<cfset fileName = arguments.objectType & ".xml" />
			<cfelseif variables.FileSystem.checkFileExists(defPath,arguments.objectType & ".xml.cfm")>
				<cfset fileName = arguments.objectType & ".xml.cfm" />
			<cfelseif variables.FileSystem.checkFileExists(defPath & arguments.objectType & "/",arguments.objectType & ".xml")>
				<cfset fileName = arguments.objectType & "/" & arguments.objectType & ".xml" />
			<cfelseif variables.FileSystem.checkFileExists(defPath & arguments.objectType & "/",arguments.objectType & ".xml.cfm")>
				<cfset fileName = arguments.objectType & "/" & arguments.objectType & ".xml.cfm" />
			</cfif>
			<cfif fileName NEQ 0>
				<cfbreak />
			</cfif>
		</cfloop>
		
		<cfif fileName NEQ 0>
			<cfset theXML = XMLParse(defPath & fileName) />
			<cfset xmlConditions = XMLSearch(theXML,"//condition") />
			<cfset xmlContexts = XMLSearch(theXML,"//context") />
			<cfset xmlProperties = XMLSearch(theXML,"//property") />

			<cfloop array="#xmlConditions#" index="theCondition">
				<cfset theConditions[theCondition.XmlAttributes.name] = theCondition.XmlAttributes />
			</cfloop>
	
			<cfloop array="#xmlContexts#" index="theContext">
				<cfset theContexts[theContext.XmlAttributes.name] = theContext.XmlAttributes />
				<cfset ReturnStruct.FormContexts[theContext.XmlAttributes.name] = theContext.XmlAttributes.formName />
			</cfloop>
	
			<cfloop array="#xmlProperties#" index="theProperty">
				<cfset theName = theProperty.XmlAttributes.name />
				<cfif StructKeyExists(theProperty.XmlAttributes,"desc")>
					<cfset theDesc = theProperty.XmlAttributes.desc />
				<cfelse>
					<cfset theDesc = determineLabel(theName) />
				</cfif>
				<cfif theDesc NEQ theName>
					<cfset ReturnStruct.PropertyDescs[theName] = theDesc />
					<cfif StructKeyExists(theProperty.XmlAttributes,"clientfieldname")>
						<cfset ReturnStruct.ClientFieldDescs[theProperty.XmlAttributes.clientfieldname] = theDesc />
					<cfelse>
						<cfset ReturnStruct.ClientFieldDescs[theName] = theDesc />
					</cfif>
				</cfif>
			</cfloop>
			<cfloop array="#xmlProperties#" index="theProperty">
				<cfset theRules = XMLSearch(theProperty,"rule") />
				<cfloop array="#theRules#" index="theRule">
					<cfset theVal = {} />
					<cfset theVal.PropertyName = theProperty.XmlAttributes.name />
					<cfif StructKeyExists(theProperty.XmlAttributes,"desc")>
						<cfset theVal.PropertyDesc = theProperty.XmlAttributes.desc />
					<cfelse>
						<cfset theVal.PropertyDesc = determineLabel(theVal.PropertyName) />
					</cfif>
					<cfif StructKeyExists(theProperty.XmlAttributes,"clientfieldname")>
						<cfset theVal.ClientFieldName = theProperty.XmlAttributes.clientfieldname />
					<cfelse>
						<cfset theVal.ClientFieldName = theVal.PropertyName />
					</cfif>
					<cfset theVal.ValType = theRule.XmlAttributes.type />
					<cfset theVal.Parameters = StructNew() />
					<cfset theParams = XMLSearch(theRule,"param") />
					<cfloop array="#theParams#" index="theParam">
						<cfset StructAppend(theVal.Parameters,theParam.XmlAttributes) />
						<cfloop list="CompareProperty,DependentProperty" index="PropertyType">
							<cfif StructKeyExists(theParam.XmlAttributes,PropertyType & "Name")>
								<cfif StructKeyExists(ReturnStruct.PropertyDescs,theParam.XmlAttributes[PropertyType & "Name"])>
									<cfset theVal.Parameters[PropertyType & "Desc"] = ReturnStruct.PropertyDescs[theParam.XmlAttributes[PropertyType & "Name"]] />
								<cfelse>
									<cfset theVal.Parameters[PropertyType & "Desc"] = determineLabel(theParam.XmlAttributes[PropertyType & "Name"]) />
								</cfif>
							</cfif>
						</cfloop>
					</cfloop>
					<cfif StructKeyExists(theRule.XmlAttributes,"failureMessage")>
						<cfset theVal.FailureMessage = theRule.XmlAttributes.failureMessage />
					</cfif>
					<cfif StructKeyExists(theRule.XmlAttributes,"condition") AND StructKeyExists(theConditions,theRule.XmlAttributes.condition)>
						<cfset theVal.Condition = theConditions[theRule.XmlAttributes.condition] />
					<cfelse>
						<cfset theVal.Condition = {} />
					</cfif>
					<cfif StructKeyExists(theRule.XmlAttributes,"contexts") AND NOT ListFindNoCase(theRule.XmlAttributes.contexts,"*")>
						<cfloop list="#theRule.XmlAttributes.contexts#" index="theContext">
							<cfif NOT StructKeyExists(ReturnStruct.Validations.Contexts,theContext)>
								<cfset ReturnStruct.Validations.Contexts[theContext] = ArrayNew(1) />
							</cfif>
							<cfif StructKeyExists(theContexts,theContext)>
								<cfset theVal.FormName = theContexts[theContext].formName />
							</cfif>
							<cfset ArrayAppend(ReturnStruct.Validations.Contexts[theContext],theVal) />
						</cfloop>
					<cfelse>
						<cfset ArrayAppend(ReturnStruct.Validations.Contexts["___Default"],theVal) />
						<cfset theVal.FormName = variables.ValidateThisConfig.defaultFormName />
					</cfif>
				</cfloop>
			</cfloop>
			<!--- Add all default rules back into each context --->
			<cfloop collection="#ReturnStruct.Validations.Contexts#" item="theContext">
				<cfif theContext NEQ "___Default">
					<cfloop array="#ReturnStruct.Validations.Contexts.___Default#" index="theVal">
						<cfset ArrayAppend(ReturnStruct.Validations.Contexts[theContext],theVal) />
					</cfloop>
				</cfif>
			</cfloop>
		<cfelse>
			<!--- TODO: We're not going to throw an error if the file is not found.  Rather we'll just end up with a BO validator with no rules in it.
					It would be nice to have a way of notifying the user of this for debugging purposes. trying a throw within a try for now. --->
			<cftry>
				<cfthrow type="ValidateThis.core.XMLFileReader.#arguments.objectType#.xml.NotFoundIn.#defPath#" detail="The rule definition file for #arguments.objectType# was not found in #defPath#." />
				<cfcatch type="any"></cfcatch>
			</cftry>
		</cfif>
		
		<cfreturn ReturnStruct />
	</cffunction>
	
	<cffunction name="determineLabel" returntype="string" output="false" access="private">
	<cfargument name="label" type="string" required="true" />
	
	<!--- Note: this is a stop-gap measure to put this functionality in place. 
		The whole metadata population system will be refactored soon. --->
	
	<cfset var i = "" />
	<cfset var char = "" />
	<cfset var result = "" />
	
	<cfloop from="1" to="#len(arguments.label)#" index="i">
		<cfset char = mid(arguments.label, i, 1) />
		
		<cfif i eq 1>
			<cfset result = result & ucase(char) />
		<cfelseif asc(lCase(char)) neq asc(char)>
			<cfset result = result & " " & ucase(char) />
		<cfelse>
			<cfset result = result & char />
		</cfif>
	</cfloop>

	<cfreturn result />	
	</cffunction>


</cfcomponent>
	

