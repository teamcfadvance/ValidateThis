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
<!--- Set up parameters for the Demo --->
<cfparam name="Form.NoJS" default="false" />
<cfparam name="Form.Context" default="Register" />
<cfparam name="Form.UserId" default="0" />
<cfparam name="Form.Locale" default="en_US" />
<cfset StructAppend(Form,URL,true) />
<p>Welcome to the <strong>ValidateThis</strong> i18n Demo Page.
	<ul><strong>Demo Options:</strong>
		<cfoutput>
		<cfif Form.NoJS>
			<li><a href="index.cfm?NoJS=false&Context=#Form.Context#&Locale=#Form.Locale#">Turn on JS Validations</a></li>
		<cfelse>
			<li><a href="index.cfm?NoJS=true&Context=#Form.Context#&Locale=#Form.Locale#">Turn off JS Validations</a></li>
		</cfif>
		<cfif Form.Locale EQ "en_US">
			<li><a href="index.cfm?NoJS=#Form.NoJS#&Context=#Form.Context#&Locale=fr_FR">French Version</a></li>
		<cfelse>
			<li><a href="index.cfm?NoJS=#Form.NoJS#&Context=#Form.Context#">English Version</a></li>
		</cfif>
		<li><a href="index.cfm?NoJS=#Form.NoJS#&Locale=#Form.Locale#">Register a New User</a></li>
		<li><a href="index.cfm?Context=Profile&NoJS=#Form.NoJS#&Locale=#Form.Locale#">Edit an Existing User</a></li>
		<li><a href="../index.cfm">Back to the Home Page</a></li>
		</cfoutput>
	</ul>
</p>
<p>This sample form includes hints which indicate the various validations that have been defined for the business object that underlies the form.</p>
<p>Use the text links above to toggle JavaScript validations to see both the client-side and server-side validations in action. You can also use the links to toggle between English and French validation failure messages, both client-side and server-side.</p>
<p>All of the validations are driven by a simple xml file, which is used to define the business rules that apply.  You can view the xml file <a href="model/user.xml" target="_blank">here</a>.</p>
<p>Note that only the validation failure messages are internationalized - the form field names will always appear in English. Also note that for the purposes of this demo I translated all of my failure messages from English to French using Google Language Tools, so the translations may be off a bit ;-)</p>
<p>Please refer to <a href="http://www.silverwareconsulting.com/index.cfm/ValidateThis" target="_blank">my blog</a> for more detailed information about the framework.</p>
