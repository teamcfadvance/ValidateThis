<!---
	
	Copyright 2010, Bob Silverberg
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
--->
<cfcomponent output="false" extends="BaseAnnotationTypeReader" hint="I am a responsible for reading and processing VTML annotations.">

    <cffunction name="init" returnType="any" access="public" output="false" hint="I build a new VTML AnnotationTypeReader">
       <cfset super.init(argumentCollection=arguments) />
        
		<cfscript>
		  /*
		  variables.VTML = {		  
		      rulePattern = '^[\w].*[\([\w=?\w,?]+]?\)]?.*[\[.*\]]?.*[{.*}]?.*[".*"]?.*[\w]?\|?[\w]?[:\w]?(\+|;)?(\s|\n)?',
		      valTypePattern = {test='^\w+'},
		      parametersPattern = {test='\(.*\)',mask="\(|\)""},
		      contextsPattern = {test='\[.*\]',mask="\[|\]""},
		      failureMessagePattern = {test = '".*"'},
		      conditionPattern = {test = '[.*]?(\{.*\})',mask="\{|\}""},
		      formPattern = {test = '\w+\|\w+:?\w+$'},
		      appenderPattern = {test = '(\+|;)'}		  
		  }
		  */
		</cfscript>
				
        <cfreturn this />
    </cffunction>
	
	<cffunction name="isThisFormat" returnType="boolean" access="public" output="false" hint="I determine whether the annotation value contains this type of format">
		<cfargument name="annotationValue" type="string" required="true" />
		
		<cfif reFind(variables.VTML.rulePattern,trim(arguments.annotationValue))>
            <cfreturn true />
        <cfelse>
            <cfreturn false />
		</cfif>
		
	</cffunction>

	<cffunction name="loadRules" returnType="void" access="public" output="false" hint="I take the object metadta and reformat it into private properties">
		<cfargument name="metadataSource" type="any" required="true" hint="the object metadata" />
		
		<cfif structKeyExists(arguments.metadataSource,"vtConditions")>
			<cfset processConditions(arguments.metadataSource.vtConditions) />
		</cfif>
		<cfif structKeyExists(arguments.metadataSource,"vtContexts")>
			<cfset processContexts(arguments.metadataSource.vtContexts) />
		</cfif>
		<cfif structKeyExists(arguments.metadataSource,"properties")>
			<cfset processPropertyDescs(arguments.metadataSource.properties) />
			<cfset processPropertyRules(arguments.metadataSource.properties) />
		</cfif>

	</cffunction>

	<cffunction name="reformatProperties" returnType="array" access="private" output="false" hint="I translate metadata into an array of properties to be used by the BaseMetadataProcessor">
		<cfargument name="properties" type="any" required="true" />
		<cfset var theProperty = 0 />
		<cfset var newProperty = 0 />
		<cfset var theProperties = [] />

		<cfloop array="#arguments.properties#" index="theProperty">
			<cfset newProperty = {name=theProperty.name} />
			<cfif StructKeyExists(theProperty,"vtDesc")>
				<cfset newProperty.desc = theProperty.vtDesc />
			<cfelseif structKeyExists(theProperty,"displayname")>
				<cfset newProperty.desc = theProperty.displayname />
			</cfif>
			<cfif StructKeyExists(theProperty,"vtClientFieldname")>
				<cfset newProperty.clientfieldname = theProperty.vtClientFieldname />
			</cfif>
			<cfif StructKeyExists(theProperty,"vtRules")>
				<cfif isJSON(theProperty.vtRules)>
					<cfset newProperty.rules = deserializeJSON(theProperty.vtRules) />
				<cfelse>
					<cfthrow type="ValidateThis.core.annotationTypeReaders.AnnotationTypeReader_JSON.InvalidJSON" detail="The contents of a vtRules annotation on the #theProperty.name# property (#theProperty.vtRules#) does not contain valid JSON." />
				</cfif>
			</cfif>
			
			<cfset arrayAppend(theProperties,newProperty) />
		</cfloop>
		<cfreturn theProperties />
	</cffunction>

	<cffunction name="processPropertyDescs" returnType="any" access="private" output="false" hint="I translate metadata into an array of properties to be used by the BaseMetadataProcessor">
		<cfargument name="properties" type="any" required="true" />
		
		<cfset super.processPropertyDescs(reformatProperties(arguments.properties)) />

	</cffunction>
	
	<cffunction name="processPropertyRules" returnType="any" access="private" output="false" hint="I translate metadata into an array of properties to be used by the BaseMetadataProcessor">
		<cfargument name="properties" type="any" required="true" />
		
		<cfset super.processPropertyRules(reformatProperties(arguments.properties)) />

	</cffunction>
	
	
	<!--- PRIVATE VTML CONVERSION METHODS --->
    <cffunction name="getElementFromVTMLRule" returntype="any" access="private" output="false">
        <cfargument name="theString" type="string" required="true" />
        <cfargument name="thePos" type="struct" required="true" />
        <cfargument name="mask" type="string" required="false" default="" />
        <cfset var result = "" />
            <cfset result = mid(arguments.theString,arguments.thePos.pos[1],arguments.thePos.len[1]) />
            <cfif len(arguments.mask)>
                <cfset result = reReplace(result,arguments.mask,"","all") />
            </cfif>
        <cfreturn result />
    </cffunction>

    <cffunction name="createParametersStruct" returntype="struct" access="private" output="false">
        <cfargument name="theString" type="string" required="true" />
        <cfset var result = {} />
        <cfset var param = {} />
        <cfset var key = {} />
        <cfset var test = 0 />
        <cfset var splitPairs = 0 />
        <cfset var pair = 0 />
        <cfset var splitParams = 0 />
        <cftry>
            <cfset test = reFind("(\w+=\w+),?",arguments.theString) />
            <cfif test>
                <cfset splitPairs =  arguments.theString.split(",") />
                <cfif isArray(splitPairs) and ArrayLen(splitPairs) gt 0>
                    <cfloop array="#splitPairs#" index="pair">
                        <cfset splitParams = pair.split("=") />
                        <cfif isArray(splitParams) and ArrayLen(splitParams) eq 2>
                            <cfset structInsert(key,splitParams[1],splitParams[2]) />
                            <cfset structAppend(result,key) />
                        </cfif>
                    </cfloop>
                </cfif>
            </cfif>
            <cfcatch><cfthrow object="#cfcatch#" /></cfcatch>
        </cftry>
        <cfreturn result />
    </cffunction>

    <cffunction name="createConditionStruct" returntype="struct" access="private" output="false">
        <cfargument name="theString" type="string" required="true" />
        <cfset var result = {} />
        <!---  TODO: Set  Conditions From VTML --->
        <cfreturn result />
    </cffunction>

    <cffunction name="createContextsStruct" returntype="any" access="private" output="false">
        <cfargument name="theString" type="string" required="true" />
        <cfset var result = [] />
        <cfset var param = {} />
        <cfset var key = {} />
        <cfset var test = 0 />
        <cfset var splitPairs = 0 />
        <cfset var pair = 0 />
        <cfset var splitParams = 0 />
        <cftry>
            <cfset test = reFind("(\w+\|\w+),?",arguments.theString) />
            <cfif test>
                <cfset splitPairs =  arguments.theString.split(",") />
                <cfif isArray(splitPairs) and ArrayLen(splitPairs) gt 0>
                    <cfloop array="#splitPairs#" index="pair">
                        <cfset splitParams = pair.split("|") />
                        <cfif isArray(splitParams) and ArrayLen(splitParams) eq 2>
                            <cfset structInsert(key,"context",splitParams[1]) />
                            <cfset structInsert(key,"formName",splitParams[2]) />
                            <cfset arrayAppend(result,key) />
                        </cfif>
                    </cfloop>
                </cfif>
            </cfif>
            <cfcatch></cfcatch>
        </cftry>
        <cfreturn result />
    </cffunction>
</cfcomponent>
