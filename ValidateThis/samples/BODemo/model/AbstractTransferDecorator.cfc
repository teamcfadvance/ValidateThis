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
<cfcomponent output="false" extends="transfer.com.TransferDecorator">

	<cffunction name="configure" access="private" returntype="void" hint="I am like init() but for decorators">
		<cfset variables.myInstance = StructNew() />
		<cfset variables.myInstance.CleanseInput = true />
		<cfset variables.myInstance.ObjectDesc = "Friendly Object Name" />
	</cffunction>

	<!--- These methods are required for ValidateThis integration --->
	
	<cffunction name="setUp" access="public" returntype="void" hint="I am run after configure via the AfterNewObserver">
		<cfset setValidator(getValidateThis().getValidator(getClassName(),getDirectoryFromPath(getCurrentTemplatePath()))) />
		<!--- Note: the next statement is NOT required for ValidateThis integration, it's part of the demo code --->
		<cfset setTheGateway(ListFirst(getClassName(),".")) />
	</cffunction>

	<cffunction name="onMissingMethod" access="public" output="false" returntype="Any" hint="Very useful!">
		<!--- This is used to help communicate with the BOValidator, which is accessed via getValidator() --->
		<cfargument name="missingMethodName" type="any" required="true" />
		<cfargument name="missingMethodArguments" type="any" required="true" />

		<cfset var returnValue = "">
		<cfset var Validator = getValidator() />
		
		<cfif arguments.missingMethodName EQ "validate">
			<cfset arguments.missingMethodArguments.theObject = this />
		</cfif>
		
		<cfinvoke component="#Validator#" method="#arguments.missingMethodName#" argumentcollection="#arguments.missingMethodArguments#" returnvariable="returnValue" />
		<!--- trap null values --->
		<cfif NOT IsDefined("returnValue")>
			<cfset returnValue = "" />
		</cfif>
		<cfreturn returnValue />
		
	</cffunction>

	<cffunction name="testCondition" access="Public" returntype="boolean" output="false" hint="I dynamically evaluate a condition and return true or false.">
		<cfargument name="Condition" type="any" required="true" />
		
		<cfreturn Evaluate(arguments.Condition)>

	</cffunction>

	<cffunction name="getValidateThis" access="public" output="false" returntype="any">
		<cfreturn variables.ValidateThis />
	</cffunction>
	<cffunction name="setValidateThis" returntype="void" access="public" output="false">
		<cfargument name="ValidateThis" type="any" required="true" />
		<cfset variables.ValidateThis = arguments.ValidateThis />
	</cffunction>

	<cffunction name="getValidator" access="public" output="false" returntype="any">
		<cfreturn variables.Validator />
	</cffunction>
	<cffunction name="setValidator" returntype="void" access="public" output="false">
		<cfargument name="Validator" type="any" required="true" />
		<cfset variables.Validator = arguments.Validator />
	</cffunction>
	
	<!--- The following three methods are not strictly required by the ValidateThis framework, 
			but do provided added functionality when used in conjunction with your service layer --->

	<cffunction name="wrapMe" access="Public" returntype="any" output="false" hint="I wrap the Transfer Object inside a BusinessObjectWrapper.">
		<cfset var theWrapper = getValidator().newBusinessObjectWrapper(this) />
		<cfset setWrapper(theWrapper) />
		<cfreturn theWrapper />
	</cffunction>
	
	<cffunction name="getWrapper" access="public" output="false" returntype="any">
		<cfreturn variables.Wrapper />
	</cffunction>
	<cffunction name="setWrapper" returntype="void" access="public" output="false">
		<cfargument name="Wrapper" type="any" required="true" />
		<cfset variables.Wrapper = arguments.Wrapper />
	</cffunction>

	<!--- The following populate() method is not strictly required by the ValidateThis framework, 
			but does include some code that makes use of the Wrapper method above and adds some 
			functionality when used in conjunction with your service layer --->
	
	<cffunction name="populate" access="public" output="false" returntype="any" hint="Populates the TO with values from the argumemnts">
		<cfargument name="args" type="any" required="yes" />
		<cfargument name="Result" type="any" required="false" default="#getValidator().newResult()#" />
		<cfargument name="FieldList" type="any" required="no" default="" />
		
		<cfset var theFieldList = "" />
		<!--- Get the MetaData and Properties --->
		<cfset var TransferMetadata = getTransfer().getTransferMetaData(getClassName()) />
		<cfset var Properties = TransferMetadata.getPropertyIterator() />
		<cfset var theProperty = 0 />
		<cfset var varName = 0 />
		<cfset var varType = 0 />
		<cfset var varValue = 0 />
		<cfset var varDesc = 0 />
		<cfset var CompType = 0 />
		<cfset var hasIterator = false />
		<cfset var theIterator = 0 />
		<cfset var theComposition = 0 />
		<cfset var ChildClass = 0 />
		<cfset var ChildPKName = 0 />
		<cfset var theChild = 0 />
		<cfset var theFailure = 0 />
		<cfset var thePropertyDescs = getValidator().getValidationPropertyDescs() />
		
		<!--- If a FieldList array was passed in, put it into theFieldList --->
		<cfif IsArray(arguments.FieldList)>
			<cfset theFieldList = ArrayToList(arguments.FieldList) />
		</cfif>
		
		<!--- Loop through the properties --->
		<cfloop condition="#Properties.hasnext()#">
			<cfset theProperty = Properties.next() />
			<cfset varName = theProperty.getName() />
			<cfset varType = theProperty.getType() />
			<cfset varDesc = varName />
			<!--- If a FieldList was passed in, use it to filter --->
			<cfif NOT ListLen(theFieldList) OR ListFindNoCase(theFieldList,varName)>
				<!--- Update the LastUpdateTimestamp --->
				<cfif varName EQ "LastUpdateTimestamp" AND varType EQ "Date">
					<cfset setLastUpdateTimestamp(Now()) />
				<!--- Special code to deal with checkbox fields, which need blanks converted to 0's --->
				<cfelseif Right(varName,4) EQ "Flag" AND varType EQ "Numeric">
					<cfif StructKeyExists(arguments.args,varName)>
						<cfset varValue = Val(arguments.args[varName]) />
					<cfelse>
						<cfset varValue = 0 />
					</cfif>
					<cfinvoke component="#this#" method="set#varName#">
						<cfinvokeargument name="#varName#" value="#varValue#" />
					</cfinvoke>
				<!--- Add the value from the args, if it exists --->
				<cfelseif StructKeyExists(arguments.args,varName)>
					<!--- get the value from the args --->
					<cfset varValue = arguments.args[varName] />
					<!--- Should all input be cleansed via HTMLEditFormat --->
					<cfif variables.myInstance.CleanseInput>
						<cfset varValue = HTMLEditFormat(varValue) />
					</cfif>
					<!--- Check for an empty value that needs to be passed as a null --->
					<cfif theProperty.getIsNullable() AND NOT Len(varValue)>
						<!--- Set the property to NULL --->
						<cfinvoke component="#this#" method="set#varName#Null" />
					<cfelse>
						<!--- Try to set the propertyvalue --->
						<cftry>
							<cfinvoke component="#this#" method="set#varName#">
								<cfinvokeargument name="#varName#" value="#varValue#" />
							</cfinvoke>
							<cfcatch type="any">
								<!--- Put the invalid value into a shadow property in the wrapper --->
								<cfset getWrapper().setInvalid(varName,varValue) />
								<cfset arguments.Result.setIsSuccess(false) />
								<cfset theFailure = StructNew() />
								<cfset theFailure.PropertyName = varName />
								<cfset theFailure.ClientFieldName = varName />
								<cfset theFailure.Type = "Datatype:" & varType />
								<cfif StructKeyExists(thePropertyDescs,varName)>
									<cfset varDesc = thePropertyDescs[varName] />
								</cfif>
								<cfset theFailure.Message = "The contents of the " & varDesc & " field must be a valid " & varType & " value." />
								<cfset arguments.Result.addFailure(theFailure) />
							</cfcatch>
						</cftry>
					</cfif>
				</cfif>
			</cfif>
		</cfloop>
		<!--- Now do the compositions --->
		<!--- Do ManyToOne and ParentOneToMany --->
		<cfloop list="ManyToOne,ParentOneToMany" index="CompType">
			<cfinvoke component="#TransferMetadata#" method="has#CompType#" returnvariable="hasIterator" />
			<cfif hasIterator>
				<cfinvoke component="#TransferMetadata#" method="get#CompType#Iterator" returnvariable="theIterator" />
				<!--- Loop through the Iterator --->
				<cfloop condition="#theIterator.hasnext()#">
					<cfset theComposition = theIterator.next() />
					<!--- The name of the composition --->
					<cfset varName = theComposition.getName() />
					<!--- The class of the child object --->
					<cfset ChildClass = theComposition.getLink().getTo() />
					<!--- The name of the PK field of the class object --->
					<cfset ChildPKName = theComposition.getLink().getToObject().getPrimaryKey().getName() />
					<!--- Does the PK value exist in the args --->
					<cfif StructKeyExists(arguments.args,ChildPKName)>
						<!--- get the value from the args --->
						<cfset varValue = arguments.args[ChildPKName] />
						<!--- Attempt to get the child object --->
						<cfset theChild = getTransfer().get(ChildClass,varValue) />
						<!--- Is it an actual object --->
						<cfif theChild.getIsPersisted()>
							<!--- Massage the method name --->
							<cfif CompType CONTAINS "Parent">
								<cfset varName = "Parent" & theComposition.getLink().getToObject().getObjectName() />
							</cfif>
							<!--- Set the child object --->
							<cfinvoke component="#this#" method="set#varName#">
								<cfinvokeargument name="transfer" value="#theChild#" />
							</cfinvoke>
						</cfif>
					</cfif>
				</cfloop>
			</cfif>
		</cfloop>
		<cfreturn arguments.Result />
			
	</cffunction>

	<!--- The following methods are not required by the ValidateThis framework, they are simply part of the demo --->

	<cffunction name="onNewProcessing" access="public" output="false" returntype="void" hint="Extra processing required for a new record.">
		<cfargument name="args" type="any" required="true" />

	</cffunction>

	<cffunction name="save" access="public" output="false" returntype="any" hint="Persists the object to the database.">
		<cfargument name="Result" type="any" required="false" default="#getValidator().newResult()#" />
		<cfargument name="Context" type="any" required="false" default="" />
		<cfset getValidator().validate(this,arguments.Context,arguments.Result) />
		<cfif arguments.Result.getIsSuccess()>
			<cfset getTheGateway().save(this) />
			<!--- TODO: Change this to use annotations when Transfer finally supports them --->
			<cfset arguments.Result.setSuccessMessage("OK, the #variables.myInstance.ObjectDesc# record has been saved.") />
		</cfif>
		<cfset arguments.Result.setTheObject(getWrapper()) />
		<cfreturn arguments.Result />
	</cffunction>

	<cffunction name="delete" access="public" output="false" returntype="any" hint="Deletes an object from the database.">
		<cfargument name="Result" type="any" required="false" default="#getValidator().newResult()#" />
		<cfset getTheGateway().delete(this) />
		<cfset arguments.Result.setSuccessMessage("OK, the #variables.myInstance.ObjectDesc# has been deleted.") />
		<cfreturn arguments.Result />
	</cffunction>

	<cffunction name="getGatewayMap" access="public" output="false" returntype="any">
		<cfreturn variables.GatewayMap />
	</cffunction>
	<cffunction name="setGatewayMap" returntype="void" access="public" output="false">
		<cfargument name="GatewayMap" type="any" required="true" />
		<cfset variables.GatewayMap = arguments.GatewayMap />
	</cffunction>

	<cffunction name="getTheGateway" access="public" output="false" returntype="any">
		<cfreturn variables.TheGateway />
	</cffunction>
	<cffunction name="setTheGateway" returntype="void" access="public" output="false">
		<cfargument name="GatewayName" type="any" required="true" />
		<cfset variables.TheGateway = variables.GatewayMap[arguments.GatewayName] />
	</cffunction>

</cfcomponent>

