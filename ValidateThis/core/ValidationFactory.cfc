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
<cfcomponent output="false" hint="I am _the_ factory object for ValidateThis, I also create BO Validators for the framework.">

	<cffunction name="init" returnType="any" access="public" output="false" hint="I build a new ValidationFactory">
		<cfargument name="ValidateThisConfig" type="struct" required="true" />

		<cfset var lwConfig = createObject("component","ValidateThis.util.BeanConfig").init(arguments.ValidateThisConfig) />
		<cfset variables.lwFactory = createObject("component","ValidateThis.util.LightWire").init(lwConfig) />
		<cfset variables.ValidateThisConfig = arguments.ValidateThisConfig />
		<cfset variables.Validators = StructNew() />

		<cfreturn this />
	</cffunction>

	<cffunction name="getBean" access="public" output="false" returntype="any" hint="I return a singleton">
		<cfargument name="BeanName" type="Any" required="false" />
		
		<cfreturn variables.lwFactory.getSingleton(arguments.BeanName) />
	
	</cffunction>
	
	<cffunction name="getValidator" access="public" output="false" returntype="any">
		<cfargument name="objectType" type="any" required="true" />
		<cfargument name="definitionPath" type="any" required="false" default="" />
		<cfargument name="theObject" type="any" required="false" default="" hint="The object from which to read annotations" />

		<cfif NOT StructKeyExists(variables.Validators,arguments.objectType)>
			<cfset variables.Validators[arguments.objectType] = createValidator(arguments.objectType,arguments.definitionPath,arguments.theObject) />
		</cfif>
		<cfreturn variables.Validators[arguments.objectType] />
		
	</cffunction>
	
	<cffunction name="createValidator" returntype="any" access="private" output="false">
		<cfargument name="objectType" type="any" required="true" />
		<cfargument name="definitionPath" type="any" required="true" />
		<cfargument name="theObject" type="any" required="true" hint="The object from which to read annotations, a blank means no object was passed" />
		
		<cfreturn CreateObject("component",variables.ValidateThisConfig.BOValidatorPath).init(arguments.objectType,getBean("FileSystem"),
			getBean("externalFileReader"),getBean("ServerValidator"),getBean("ClientValidator"),getBean("TransientFactory"),
			getBean("CommonScriptGenerator"),getBean("Version"),
			variables.ValidateThisConfig.defaultFormName,variables.ValidateThisConfig.defaultJSLib,variables.ValidateThisConfig.definitionPath,
			arguments.definitionPath,arguments.theObject) />

	</cffunction>

	<cffunction name="loadChildObjects" returntype="struct" access="public" output="false" hint="I am a utility function used to create groups of child objects, such as SRVs, CRSs and fileReaders.">
		<cfargument name="childPaths" type="string" required="true" hint="A comma delimited list of component paths" />
		<cfargument name="fileNamePrefix" type="string" required="true" hint="The expected prefix for the object type (e.g., ServerRuleValidator_)" />
		<cfargument name="childCollection" type="struct" required="false" default="#StructNew()#" hint="The structure into which to load the objects" />
		<cfargument name="initArguments" type="struct" required="false" default="#StructNew()#" hint="The arguments to be passed to the init method of each object" />
		<cfset var objNames = "" />
		<cfset var obj = 0 />
		<cfset var childPath = ""/>
		<cfset var actualPath = ""/>
		
		<cfloop list="#arguments.childPaths#" index="childPath">
			<cfset actualPath = getBean("FileSystem").getMappingPath(childPath) />
			<cfset componentPath = childPath & "." />
			<cfset objNames = getBean("FileSystem").listFiles(actualPath)/>
			<cfloop list="#objNames#" index="obj">
				<cfif ListLast(obj,".") EQ "cfc" AND obj CONTAINS arguments.fileNamePrefix>
					<cfset arguments.childCollection[replaceNoCase(ListLast(obj,"_"),".cfc","")] = CreateObject("component",componentPath & ReplaceNoCase(obj,".cfc","")).init(argumentCollection=arguments.initArguments) />
				</cfif>
			</cfloop>
		</cfloop>
		
		<cfreturn arguments.childCollection />
	</cffunction>
	
	<cffunction name="newResult" returntype="any" access="public" output="false" hint="I create a Result object.">

		<cfreturn getBean("TransientFactory").newResult() />
		
	</cffunction>

</cfcomponent>
	

