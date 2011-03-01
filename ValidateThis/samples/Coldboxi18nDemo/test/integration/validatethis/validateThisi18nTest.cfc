component extends="approot.test.BaseTestCase"
{	
	
	function setup()
	{
		//Call the super setup method to setup the app.
		super.setup();
		instance.validatethis = instance.controller.getColdboxOCM().get( "validatethis" );
		instance.i18n = instance.controller.getPlugin( "i18n" ); 
	}
	
	/*
	-----------------------------------------------------------
	getInitializationScript tests
	-----------------------------------------------------------
	*/
	function testGetInitializationScriptReturnEnglishLocaleWhenEnglishLocalePassed()
	{
		// the locale currently does nothing
		var result = instance.validatethis.getInitializationScript( locale="en_GB" );

		// assert
		assertEquals( "699edb3e16763e0807a5ee5f965da166", Hash( result ) );
	}	
	
	function testGetInitializationScriptReturnFrenchLocaleWhenFrenchLocalePassed()
	{
		// the locale currently does nothing
		var result = instance.validatethis.getInitializationScript( locale="fr_FR" );

		// assert
		assertEquals( "699edb3e16763e0807a5ee5f965da166", Hash( result ) );
	}
	
	function testGetInitializationScriptReturnDefaultLocaleWhenNoLocalePassed()
	{
		// the locale currently does nothing
		var result = instance.validatethis.getInitializationScript();

		// assert
		assertEquals( "699edb3e16763e0807a5ee5f965da166", Hash( result ) );
	}

	/*
	-----------------------------------------------------------
	getValidationScript tests
	-----------------------------------------------------------
	*/
	function testGetValidationScriptReturnDefaultLocaleWhenNoLocalePassed()
	{
		// the locale currently does nothing
		var result = instance.validatethis.getValidationScript( objectType="User" );
		debug( result );
		// assert
		assertTrue( result contains instance.i18n.getResource( "MustLikeOther" ) );
	}

	function testGetValidationScriptReturnEnglishLocaleWhenEnglishLocalePassed()
	{
		// the locale currently does nothing
		var result = instance.validatethis.getValidationScript( objectType="User", locale="en_GB" );
		debug( result );
		// assert
		assertTrue( result contains instance.i18n.getResource( "MustLikeOther" ) );
	}

	function testGetValidationScriptReturnFrenchLocaleWhenFrenchLocalePassed()
	{
		// the locale currently does nothing
		var result = instance.validatethis.getValidationScript( objectType="User", locale="fr_FR" );
		debug( result );
		
		instance.i18n.setfwlocale( "fr_FR" );
		// assert
		assertTrue( result contains instance.i18n.getResource( "MustLikeOther" ) );
	}
	
}