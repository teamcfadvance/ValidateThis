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
<cfset StructAppend(Form,URL,true) />
<p>Welcome to the <strong>ValidateThis</strong> Integrated BO <em>with cfUniForm</em> Demo Page.
	<ul><strong>Demo Options:</strong>
		<cfoutput>
		<cfif Form.NoJS>
			<li><a href="index.cfm?NoJS=false&Context=#Form.Context#&cfU=_CFU">Turn on JS Validations</a></li>
		<cfelse>
			<li><a href="index.cfm?NoJS=true&Context=#Form.Context#&cfU=_CFU">Turn off JS Validations</a></li>
		</cfif>
		<li><a href="index.cfm?NoJS=#Form.NoJS#&cfU=_CFU">Register a New User</a></li>
		<li><a href="index.cfm?Context=Profile&NoJS=#Form.NoJS#&cfU=_CFU">Edit an Existing User</a></li>
		<li><a href="../index.cfm">Back to the Home Page</a></li>
		</cfoutput>
	</ul>
</p>
<p>This sample form includes hints which indicate the various validations that have been defined for the business object that underlies the form.</p>
<p>Use the text links above to toggle JavaScript validations to see both the client-side and server-side validations in action.</p>
<p>All of the validations are driven by a simple xml file, which is used to define the business rules that apply.  You can view the xml file <a href="model/user.user.xml" target="_blank">here</a>.</p>
<p>The code for this demo integrates ValidateThis into the business objects, and uses Transfer as an ORM.</p>
<p>I am using <a href="http://www.quackfuzed.com/" target="_blank">Matt Quackenbush's</a> <a href="http://cfuniform.riaforge.org/">cfUniForm library</a> for the this demo form, and although I've done some integration between his library and mine, it (cfUniForm) is by no means a requirement of the framework.  It will work with any form built using any method.  For an example that doesn't make use of the cfUniForm library, <a href="index.cfm">click here</a>.</p>
<p>Please refer to <a href="http://www.silverwareconsulting.com/index.cfm/ValidateThis" target="_blank">my blog</a> for more detailed information about the framework.</p>
