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
	debugging tests
	-----------------------------------------------------------
	*/
	function testgetDebuggingMode()
	{
		var vtresult = instance.validatethis.newResult();

		// assert
		assertEquals( 'none', vtresult.getDebuggingMode() );
	}
	
	function testgetDebuggingInfoBeforeValidation()
	{
		var result = instance.validatethis.newResult().getDebugging();
		
		// assert
		assertEquals( 0, ArrayLen( result ) );
	}
	
	function testgetDebuggingInfoAfterValidation()
	{
		var user = EntityNew( "User" );
		user.setUserName( "John" );
		user.setUserPass( "foobar" );
		user.setVerifyPassword( "123456" );
		user.setNickname( "Aliaspooryorik" );
		user.setSalutation( "Salutation" );
		user.setFirstName( "John" );
		user.setLastName( "Whish" );
		user.setLikeCheese( 0 );
		user.setLikeChocolate( 0 );
		user.setLikeOther( "" );
		user.setAllowCommunication( 1 );
		user.setHowMuch( 100 );
	
		var result = instance.validatethis.validate( theObject=user );
		var debugging = result.getDebugging();
		
		debug( debugging );
		// assert
		assertEquals( 0, ArrayLen( debugging ) );
	}
	
	function testgetDebuggingModeCanBeSetPerValidateCall()
	{
		var user = EntityNew( "User" );
		user.setUserName( "John" );
		user.setUserPass( "foobar" );
		user.setVerifyPassword( "123456" );
		user.setNickname( "Aliaspooryorik" );
		user.setSalutation( "Salutation" );
		user.setFirstName( "John" );
		user.setLastName( "Whish" );
		user.setLikeCheese( 0 );
		user.setLikeChocolate( 0 );
		user.setLikeOther( "" );
		user.setAllowCommunication( 1 );
		user.setHowMuch( 100 );
	
		var result = instance.validatethis.validate( theObject=user, debuggingmode="info" );
		var debugging = result.getDebugging();
		
		debug( debugging );
		// assert
		assertEquals( 13, ArrayLen( debugging ) );
	}

}