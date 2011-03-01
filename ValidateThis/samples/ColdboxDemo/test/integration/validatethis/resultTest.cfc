component extends="approot.test.BaseTestCase"
{	
	
	function setup()
	{
		//Call the super setup method to setup the app.
		super.setup();
		instance.validatethis = instance.controller.getColdboxOCM().get( "validatethis" );
	}
	
	/*
	-----------------------------------------------------------
	getFailureMessagesByProperty tests
	-----------------------------------------------------------
	*/
	function testFailureMessageByProperty()
	{
		var user = EntityNew( "User" );
		var vtresult = instance.validatethis.validate( User );
		var failurestruct = vtresult.getFailureMessagesByProperty();
		
		//assert
		assertEquals( 'The How much money would you like? is required.', failurestruct.howmuch[ 1 ] );
		assertEquals( 'The How much money would you like? must be a number.', failurestruct.howmuch[ 2 ] );
		assertEquals( 'The User Group is required.', failurestruct.UserGroup[ 1 ] );
		assertEquals( 'The Email Address is required.', failurestruct.UserName[ 1 ] );
		assertEquals( 'Hey, buddy, you call that an Email Address?', failurestruct.UserName[ 2 ] );
		assertEquals( 'The Password is required.', failurestruct.UserPass[ 1 ] );
		assertEquals( 'The Password must be between 5 and 10 characters long.', failurestruct.UserPass[ 2 ] );
		assertEquals( 'The Verify Password is required.', failurestruct.VerifyPassword[ 1 ] );	
	}
	
	/*
	-----------------------------------------------------------
	getFailures tests
	-----------------------------------------------------------
	*/
	
	function testGetFailures()
	{
		var user = EntityNew( "User" );
		var vtresult = instance.validatethis.validate( User );
		var failures = vtresult.getFailures();
		
		// assert
		assertEquals( 'The Email Address is required.', failures[ 1 ].message );
		assertEquals( 'Hey, buddy, you call that an Email Address?', failures[ 2 ].message );
		assertEquals( 'The Password is required.', failures[ 3 ].message );
		assertEquals( 'The Password must be between 5 and 10 characters long.', failures[ 4 ].message );
		assertEquals( 'The Verify Password is required.', failures[ 5 ].message );
		assertEquals( 'The User Group is required.', failures[ 6 ].message );
		assertEquals( 'The How much money would you like? is required.', failures[ 7 ].message );
		assertEquals( 'The How much money would you like? must be a number.', failures[ 8 ].message );
	}
	
	/*
	-----------------------------------------------------------
	getFailureMessages tests
	-----------------------------------------------------------
	*/
	
	
	function testgetFailureMessages()
	{
		var user = EntityNew( "User" );
		var vtresult = instance.validatethis.validate( User );
		var failures = vtresult.getFailureMessages();
		
		// assert
		debug( failures );

		assertEquals( 'The Email Address is required.', failures[ 1 ] );
		assertEquals( 'Hey, buddy, you call that an Email Address?', failures[ 2 ] );
		assertEquals( 'The Password is required.', failures[ 3 ] );
		assertEquals( 'The Password must be between 5 and 10 characters long.', failures[ 4 ] );
		assertEquals( 'The Verify Password is required.', failures[ 5 ] );
		assertEquals( 'The User Group is required.', failures[ 6 ] );
		assertEquals( 'The How much money would you like? is required.', failures[ 7 ] );
		assertEquals( 'The How much money would you like? must be a number.', failures[ 8 ] );
	}
	
	
	/*
	-----------------------------------------------------------
	getFailuresAsString tests
	-----------------------------------------------------------
	*/
	function testGetFailuresAsString()
	{
		var user = EntityNew( "User" );
		var vtresult = instance.validatethis.validate( User );
		var failures = vtresult.getFailuresAsString();
		
		// assert
		assertEquals( "the email address is required.<br />hey, buddy, you call that an email address?<br />the password is required.<br />the password must be between 5 and 10 characters long.<br />the verify password is required.<br />the user group is required.<br />the how much money would you like? is required.<br />the how much money would you like? must be a number.", failures );
	}
	
	
	/*
	-----------------------------------------------------------
	getFailuresByField tests
	-----------------------------------------------------------
	*/	
	function testGetFailuresByField()
	{
		var user = EntityNew( "User" );
		var vtresult = instance.validatethis.validate( User );
		var failurestruct = vtresult.getFailuresByField();
		
		debug( failurestruct );
		
		// assert
		assertEquals( 'The How much money would you like? is required.', failurestruct.howmuch[ 1 ].message );
		assertEquals( 'The How much money would you like? must be a number.', failurestruct.howmuch[ 2 ].message );
		assertEquals( 'The User Group is required.', failurestruct.UserGroupID[ 1 ].message );
		assertEquals( 'The Email Address is required.', failurestruct.UserName[ 1 ].message );
		assertEquals( 'Hey, buddy, you call that an Email Address?', failurestruct.UserName[ 2 ].message );
		assertEquals( 'The Password is required.', failurestruct.UserPass[ 1 ].message );
		assertEquals( 'The Password must be between 5 and 10 characters long.', failurestruct.UserPass[ 2 ].message );
		assertEquals( 'The Verify Password is required.', failurestruct.VerifyPassword[ 1 ].message );	
	}
	
	/*
	-----------------------------------------------------------
	getFailureMessagesByField tests
	-----------------------------------------------------------
	*/
	function testGetFailureMessagesByField()
	{
		var user = EntityNew( "User" );
		var vtresult = instance.validatethis.validate( User );
		var failurestruct = vtresult.getFailureMessagesByField();
		
		// assert
		assertEquals( 'The How much money would you like? is required.', failurestruct.howmuch[ 1 ] );
		assertEquals( 'The How much money would you like? must be a number.', failurestruct.howmuch[ 2 ] );
		assertEquals( 'The User Group is required.', failurestruct.UserGroupID[ 1 ] );
		assertEquals( 'The Email Address is required.', failurestruct.UserName[ 1 ] );
		assertEquals( 'Hey, buddy, you call that an Email Address?', failurestruct.UserName[ 2 ] );
		assertEquals( 'The Password is required.', failurestruct.UserPass[ 1 ] );
		assertEquals( 'The Password must be between 5 and 10 characters long.', failurestruct.UserPass[ 2 ] );
		assertEquals( 'The Verify Password is required.', failurestruct.VerifyPassword[ 1 ] );
		
	}
	
	
	/*
	-----------------------------------------------------------
	getFailuresByProperty tests
	-----------------------------------------------------------
	*/
	function testGetFailuresByProperty()
	{
		var user = EntityNew( "User" );
		var vtresult = instance.validatethis.validate( User );
		var failures = vtresult.getFailuresByProperty( limit=1 );
		
		// assert
		assertEquals( 'the how much money would you like? is required.', failures.howmuch[ 1 ].message );
	}
	
	
	/*
	-----------------------------------------------------------
	getFailureMessagesByProperty tests
	-----------------------------------------------------------
	*/
	function testGetFailureMessagesByProperty()
	{
		var user = EntityNew( "User" );
		var vtresult = instance.validatethis.validate( User );
		var failures = vtresult.getFailureMessagesByProperty( limit=1 );
		
		// assert
		assertEquals( 'the how much money would you like? is required.', failures.howmuch[ 1 ] );
	}

	/*
	-----------------------------------------------------------
	getFailuresForUniForm tests
	-----------------------------------------------------------
	*/
	function testGetFailuresForUniForm()
	{
		var user = EntityNew( "User" );
		var vtresult = instance.validatethis.validate( User );
		var failures = vtresult.getFailuresForUniForm( limit=1 );
		
		// assert
		assertEquals( 'the how much money would you like? is required.', ReReplace( failures.howmuch, "<br />.*", "" ) );
	}
	
	
	/*
	-----------------------------------------------------------
	getErrors tests
	-----------------------------------------------------------
	*/
	function testGetErrors()
	{
		var user = EntityNew( "User" );
		var vtresult = instance.validatethis.validate( User );
		var failures = vtresult.getErrors();
		
		// assert
		assertEquals( 'the how much money would you like? is required.', failures.howmuch[ 1 ] );
	}
		
	
	/*
	-----------------------------------------------------------
	getFailuresAsStruct tests
	-----------------------------------------------------------
	*/
	function testGetFailuresAsStruct()
	{
		var user = EntityNew( "User" );
		var vtresult = instance.validatethis.validate( User );
		var failures = vtresult.getFailuresAsStruct();
		
		debug( failures );

		// assert
		assertEquals( 'the user group is required.', failures.usergroupid );
	}		

}