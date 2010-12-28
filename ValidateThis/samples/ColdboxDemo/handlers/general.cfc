component name="General.cfc"
{
	// Dependancy Injection
	property name="ValidateThis" inject="coldbox:myplugin:ValidateThisCB3Plugin";
	property name="MessageBox" inject="coldbox:plugin:MessageBox";


	
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
		
		// store Validator in request collection for use in the view
		rc.Validator = ValidateThis.getValidator( objectType="User" );
		
		// include javascript libraries, could do this in the layout if preferred
		$htmlhead( "<script type=""text/javascript"" src=""assets/js/jquery-1.4.4.min.js""></script>" );
		$htmlhead( "<script type=""text/javascript"" src=""assets/js/jquery.validate.min.js""></script>" );
		$htmlhead( "<script type=""text/javascript"" src=""assets/js/jquery.field.min.js""></script>" );
		// load general client side validation scripts
		$htmlhead( ValidateThis.getInitializationScript() );
		// load client side validation specific to the User and context
		$htmlhead( ValidateThis.getValidationScript( objectType="User", Context=rc.Context ) );
		
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
		
		// get ValidateThis to validate the entity
		rc.validationresult = ValidateThis.validate( theObject=rc.User, Context=rc.Context );
		
		// check for any errors
		if ( rc.validationresult.hasErrors() )
		{
			// validation has failed so redirect preserving the user and validationresult
			getPlugin("MessageBox").setMessage( type="error", messageArray=rc.validationresult.getFailureMessages() );
			flash.persistRC( 'user,validationresult' );
			setNextEvent( "general.maintain" );
		}
		else
		{
			// no errors so save and redirect
			transaction
			{
				EntitySave( rc.User );
			}
			getPlugin("MessageBox").setMessage( type="info", message="The User has been saved!" );
			setNextEvent( "general" );
		}
	}
}