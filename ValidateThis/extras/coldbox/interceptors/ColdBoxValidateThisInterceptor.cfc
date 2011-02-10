<!---
	
	Copyright 2011, John Whish & Bob Silverberg
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
--->
<cfcomponent name="ColdBoxValidateThis"
			 extends="coldbox.system.interceptor" 
			 hint="I load and configure ValidateThis" 
			 output="false">

	<!------------------------------------------- CONSTRUCTOR ------------------------------------------->

	<cffunction name="Configure" access="public" returntype="void" hint="This is the configuration method for your interceptor" output="false" >
		
		<cfscript>
			// If no definitionPath was defined, use the ModelsPath and (optionally) the ModelsExternalLocation from the ColdBox config
			if (NOT propertyExists("definitionPath"))
			{
				setProperty("definitionPath", getController().getSetting("ModelsPath") & "/");
				if (propertyExists("ModelsExternalLocation") AND Len(getController().getSetting("ModelsExternalLocation")))
				{
					setProperty("definitionPath", getProperty("definitionPath") & getController().getSetting("ModelsExternalLocation"));
				}
			}
			
			// Coldbox has i18n configured
			if (getController().settingExists("defaultLocale") AND getController().getSetting("defaultLocale") neq "")
			{
				if (NOT propertyExists("defaultLocale"))
				{
					// set ValidateThis up to use ColdBox default Locale
					setProperty("defaultLocale", getController().getSetting("defaultLocale"));
				}
				if (NOT propertyExists("translatorPath"))
				{
					// a custom translator hasn't been set so use ValidateThis.extras.coldbox.ColdBoxRBTranslator
					setProperty("translatorPath", "ValidateThis.extras.coldbox.ColdBoxRBTranslator");
				}
			}
			
			// name of key to use in the cache
			if (NOT propertyExists('ValidateThisCacheKey'))
			{
				setProperty('ValidateThisCacheKey',"ValidateThis");
			}
		</cfscript>
				
	</cffunction>
	
	<!------------------------------------------- INTERCEPTION POINTS ------------------------------------------->

	<!--- After Aspects Load --->
	<cffunction name="afterAspectsLoad" access="public" returntype="void" output="false" hint="Load ValidateThis after configuration has loaded">
		<cfargument name="event" 		 required="true" type="any" hint="The event object.">
		<cfargument name="interceptData" required="true" type="struct" hint="interceptData of intercepted info.">
		
		<cfscript>
		var ValidateThis = "";
			
		ValidateThis = CreateObject("component","ValidateThis.ValidateThis").init(getProperties());
		
		if (getController().settingExists("defaultLocale") AND getController().getSetting("defaultLocale") neq "")
		{
			// inject the ColdBox resource bundle into the translator, this does assume that if a custom translator has been defined it will have a setResourceBundle() method
			try
			{
				ValidateThis.getBean("Translator").setResourceBundle(getPlugin("ResourceBundle"));
			}
			catch(Any exception) 
			{
				// using the logger plugin for compatibility with ColdBox 2.6 and ColdBox 3
				getPlugin("logger").error("ColdBoxValidateThisInterceptor error: setResourceBundle method not found in  #getProperty('translatorPath')#");
			}
		}
			
		// ValidateThis is loaded and configured so cache it
		getColdboxOCM().set(getProperty('ValidateThisCacheKey'), ValidateThis, 0);
		
		// using the logger plugin for compatibility with ColdBox 2.6 and ColdBox 3
		getPlugin("logger").info("ValidateThis " & ValidateThis.getVersion() &  " loaded", SerializeJSON(ValidateThis.getValidateThisConfig()));
		</cfscript>
		
	</cffunction>

</cfcomponent>