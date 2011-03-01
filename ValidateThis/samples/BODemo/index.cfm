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
<cfsilent>
	<!--- Check for reinit and grab a copy of the BeanFactory --->
	<cfif StructKeyExists(url,"init") OR NOT StructKeyExists(application,"BeanFactory")>
		<cfset application.BeanFactory = CreateObject("component","coldspring.beans.DefaultXmlBeanFactory") />
		<cfset application.BeanFactory.loadBeans(beanDefinitionFileName=expandPath('/validateThis/samples/BODemo/model/config/Coldspring.xml.cfm'),constructNonLazyBeans=true) />
	</cfif>
</cfsilent>
<cfparam name="url.cfU" default="" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
	<head>
		<title>ValidateThis Demo Page</title>
		<link href="../css/demostyle.css" type="text/css" rel="stylesheet" />
		<cfif NOT Len(url.cfU)>
			<link href="../css/uni-form-styles.css" type="text/css" rel="stylesheet" media="all" />
		</cfif>
	</head>
	<body>
	<div id="container">
		<div id="sidebar">
			<cfinclude template="theSidebar#url.cfU#.cfm" />
		</div>		
		<div id="content">
			<cfinclude template="theForm#url.cfU#.cfm" />
		</div>
	</div>
	</body>
</html>
