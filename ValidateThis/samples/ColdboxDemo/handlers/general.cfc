/* 

	Copyright 2011, Bob Silverberg & John Whish
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.

*/
component 
{
	// Dependancy Injection
	property name="ValidateThis" inject="ocm:ValidateThis";

	/**
	 * I list users
	 */
	void function index( required event )
	{
		var rc = arguments.event.getCollection();
		
		rc.PageHeading = "User List";
		
		rc.Users = EntityLoad( "User" );
	
		arguments.event.setView( "general/index" );
	}
	
	/**
	 * I show the form for adding / editing a user
	 */
	void function maintain( required event )
	{
		var rc = arguments.event.getCollection();
		
		if ( StructKeyExists( rc, "userid" ) )
		{
			// editing existing user
			rc.User = EntityLoadByPK( "User", rc.userid );
		}
		else if ( !StructKeyExists( rc, "User" ) )
		{
			// user not passed in flash, so create a new user
			rc.User = EntityNew( "User" );
		}
		
		// check if a new or existing user
		if ( rc.User.getUserId() == "" ) 
		{
			rc.Context = "Register";
			rc.PageHeading = "Registering a new User";
		}
		else
		{
			rc.Context = "Profile";
			rc.PageHeading = "Editing an existing User";
		}
		
		// check if user has a usergroup
		if ( rc.User.hasUserGroup() )
		{
			rc.userGroupId = rc.User.getUserGroup().getUserGroupId();
		}
		else
		{
			rc.userGroupId = "";
		}
		
		// validationresult may exists if validation failed
		arguments.event.paramValue( "ValidationResult", ValidateThis.newResult() );
		
		// store Validator for this object in request collection for use in the view
		rc.Validator = ValidateThis.getValidator( objectType="User" );
		
		// check if javascript validation is enabled
		if ( !rc.nojs ) 
		{
			// load general client side validation scripts
			$htmlhead( ValidateThis.getInitializationScript() );
			// load client side validation specific to the User and context
			$htmlhead( ValidateThis.getValidationScript( objectType="User", Context=rc.Context ) );
		}
		
		// render the view
		arguments.event.setView( "general/maintain" );
	}
	
	/**
	 * I validate and save the user
	 */
	void function save( required event )
	{
		var rc = arguments.event.getCollection();
		
		if ( Val( rc.userid ) > 0 )
		{
			// existing user so edit
			rc.User = EntityLoadByPK( "User", Val( rc.userid ) );
			rc.Context = "Profile";
		}
		else
		{
			// new user
			rc.User = EntityNew( "User" );
			rc.Context = "Register";
		}
		
		populateModel( model=rc.User, exclude="userid" );
		
		// get ValidateThis to validate the entity for the given context
		rc.validationresult = ValidateThis.validate( theObject=rc.User, Context=rc.Context );
		
		// check for any errors
		if ( rc.validationresult.hasErrors() )
		{
			// validation has failed so redirect preserving the user and validationresult
			getPlugin( "MessageBox" ).setMessage( type="error", messageArray=rc.validationresult.getFailureMessages() );
			flash.persistRC( "user,validationresult" );
			setNextEvent( "general.maintain" );
		}
		else
		{
			// no errors so save and redirect
			transaction
			{
				EntitySave( rc.User );
			}
			getPlugin( "MessageBox" ).setMessage( type="info", message="The User has been saved!" );
			setNextEvent( "general" );
		}
	}
}