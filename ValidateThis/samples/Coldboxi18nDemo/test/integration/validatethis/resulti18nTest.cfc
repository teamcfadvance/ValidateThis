component extends="approot.test.BaseTestCase"
{	
	
	function setup()
	{
		//Call the super setup method to setup the app.
		super.setup();
		instance.validatethis = instance.controller.getColdboxOCM().get( "validatethis" );
		instance.i18n = getPlugin( "i18n" );
	}
	
	/*
	-----------------------------------------------------------
	getFailureMessagesByProperty tests
	-----------------------------------------------------------
	*/
	function testFailureMessageIsDefaultLocaleWhenNoLocalePassed()
	{
	
		var rbmessage = instance.i18n.getResource( "VerifyPasswordRequired" );
		var user = EntityNew( "User" );
		var vtresult = instance.validatethis.validate( User );
		var failurestruct = vtresult.getFailureMessagesByProperty();
		debug( failurestruct );
		var failuremessage = failurestruct.VerifyPassword[ 1 ];
		//assert
		assertTrue( failuremessage == rbmessage, "expected '#rbmessage#', got '#failuremessage#'" );
	}
	
	function testFailureMessageIsFrenchWhenFrenchLocalePassed()
	{
		// assert
		instance.i18n.setfwlocale( "fr_FR" );
		var rbmessage = instance.i18n.getResource( "VerifyPasswordRequired" );
		var user = EntityNew( "User" );
		var vtresult = instance.validatethis.validate( User );
		var failuremessage = vtresult.getFailureMessagesByProperty( locale="fr_FR" ).VerifyPassword[ 1 ];
		// assert
		
		assertTrue( failuremessage == rbmessage, "expected '#rbmessage#', got '#failuremessage#'" );
	}
	
	function testFailureMessageIsEnglishWhenEnglishLocalePassed()
	{
		var user = EntityNew( "User" );
		var rbmessage = instance.i18n.getResource( "VerifyPasswordRequired" );
		var vtresult = instance.validatethis.validate( User );
		var failuremessage = vtresult.getFailureMessagesByProperty( locale="en_GB" ).VerifyPassword[ 1 ];
		// assert
		
		assertEquals( rbmessage, failuremessage );
		
		debug( vtresult.getRuleDebugging() );
	}
	
	/*
	-----------------------------------------------------------
	getFailures tests
	-----------------------------------------------------------
	*/
	function testGetFailuresReturnFrenchWhenFrenchLocalePassed()
	{
		instance.i18n.setfwlocale( "fr_FR" );
		var user = EntityNew( "User" );
		var rbmessage = instance.i18n.getResource( "EmailRequired" );
		var vtresult = instance.validatethis.validate( User );
		var failures = vtresult.getFailures( locale="fr_FR" );
		
		// assert
		assertEquals( rbmessage, failures[ 1 ].message );
	}
	
	function testGetFailuresReturnEnglishWhenEnglishLocalePassed()
	{
		var user = EntityNew( "User" );
		var rbmessage = instance.i18n.getResource( "EmailRequired" );
		var vtresult = instance.validatethis.validate( User );
		var failures = vtresult.getFailures( locale="en_GB" );
		
		// assert
		assertEquals( rbmessage, failures[ 1 ].message );
	}
	
	function testGetFailuresReturnEnglishWhenNoLocalePassed()
	{
		var user = EntityNew( "User" );
		var rbmessage = instance.i18n.getResource( "EmailRequired" );
		var vtresult = instance.validatethis.validate( User );
		var failures = vtresult.getFailures();
		
		// assert
		assertEquals( rbmessage, failures[ 1 ].message );
	}
	
	/*
	-----------------------------------------------------------
	getFailureMessages tests
	-----------------------------------------------------------
	*/
	
	function testGetFailureMessagesReturnEnglishWhenNoEnglishLocalePassed()
	{
		var user = EntityNew( "User" );
		var rbmessage = instance.i18n.getResource( "EmailRequired" );
		var vtresult = instance.validatethis.validate( User );
		var failures = vtresult.getFailureMessages( locale="en_GB" );
		
		// assert
		assertEquals( rbmessage, failures[ 1 ] );
	}
	
	function testGetFailureMessagesReturnFrenchWhenNoFrenchLocalePassed()
	{
		instance.i18n.setfwlocale( "fr_FR" );
		var user = EntityNew( "User" );
		var rbmessage = instance.i18n.getResource( "EmailRequired" );
		var vtresult = instance.validatethis.validate( User );
		var failures = vtresult.getFailureMessages( locale="fr_FR" );
		
		// assert
		assertEquals( rbmessage, failures[ 1 ] );
	}
	
	function testGetFailureMessagesReturnEnglishWhenNoLocalePassed()
	{
		var user = EntityNew( "User" );
		var rbmessage = instance.i18n.getResource( "EmailRequired" );
		var vtresult = instance.validatethis.validate( User );
		var failures = vtresult.getFailureMessages();
		
		// assert
		assertEquals( rbmessage, failures[ 1 ] );
	}
	
	
	/*
	-----------------------------------------------------------
	getFailuresAsString tests
	-----------------------------------------------------------
	*/
	function testGetFailuresAsStringReturnEnglishWhenNoLocalePassed()
	{
		var user = EntityNew( "User" );
		var rbmessage = instance.i18n.getResource( "EmailRequired" );
		var vtresult = instance.validatethis.validate( User );
		var failures = vtresult.getFailuresAsString();
		
		// assert
		assertEquals( rbmessage, ReReplace( failures, "<br />.+", "" ) );
	}
	
	function testGetFailuresAsStringReturnFrenchWhenFrenchLocalePassed()
	{
		instance.i18n.setfwlocale( "fr_FR" );
		var user = EntityNew( "User" );
		var rbmessage = instance.i18n.getResource( "EmailRequired" );
		var vtresult = instance.validatethis.validate( User );
		var failures = vtresult.getFailuresAsString( locale="fr_FR" );
		
		// assert
		assertEquals( rbmessage, ReReplace( failures, "<br />.+", "" ) );
	}	
	
	function testGetFailuresAsStringReturnEnglishWhenEnglishLocalePassed()
	{
		var user = EntityNew( "User" );
		var rbmessage = instance.i18n.getResource( "EmailRequired" );
		var vtresult = instance.validatethis.validate( User );
		var failures = vtresult.getFailuresAsString( locale="en_GB" );
		
		// assert
		assertEquals( rbmessage, ReReplace( failures, "<br />.+", "" ) );
	}
	
	/*
	-----------------------------------------------------------
	getFailuresByField tests
	-----------------------------------------------------------
	*/	
	function testGetFailuresByFieldReturnEnglishWhenEnglishLocalePassed()
	{
		var user = EntityNew( "User" );
		var rbmessage = instance.i18n.getResource( "HowMuchRequired" );
		var vtresult = instance.validatethis.validate( User );
		var failures = vtresult.getFailuresByField( limit=1, locale="en_GB" );
		
		// assert
		assertEquals( rbmessage, failures.howmuch[ 1 ].message );
	}	

	function testGetFailuresByFieldReturnFrenchWhenFrenchLocalePassed()
	{
		instance.i18n.setfwlocale( "fr_FR" );
		var user = EntityNew( "User" );
		var rbmessage = instance.i18n.getResource( "HowMuchRequired" );
		var vtresult = instance.validatethis.validate( User );
		var failures = vtresult.getFailuresByField( limit=1, locale="fr_FR" );
		
		// assert
		assertEquals( rbmessage, failures.howmuch[ 1 ].message );
	}
	
	function testGetFailuresByFieldReturnDefaultLocaleWhenNoLocalePassed()
	{
		var user = EntityNew( "User" );
		var rbmessage = instance.i18n.getResource( "HowMuchRequired" );
		var vtresult = instance.validatethis.validate( User );
		var failures = vtresult.getFailuresByField( limit=1 );
		
		// assert
		assertEquals( rbmessage, failures.howmuch[ 1 ].message );
	}
	
	/*
	-----------------------------------------------------------
	getFailureMessagesByField tests
	-----------------------------------------------------------
	*/
	function testGetFailureMessagesByFieldReturnDefaultLocaleWhenNoLocalePassed()
	{
		var user = EntityNew( "User" );
		var rbmessage = instance.i18n.getResource( "HowMuchRequired" );
		var vtresult = instance.validatethis.validate( User );
		var failures = vtresult.getFailureMessagesByField( limit=1 );
		
		// assert
		assertEquals( rbmessage, failures.howmuch[ 1 ] );
	}
	
	function testGetFailureMessagesByFieldReturnEnglishWhenEnglishLocalePassed()
	{
		var user = EntityNew( "User" );
		var rbmessage = instance.i18n.getResource( "HowMuchRequired" );
		var vtresult = instance.validatethis.validate( User );
		var failures = vtresult.getFailureMessagesByField( locale="en_GB", limit=1 );
		
		// assert
		assertEquals( rbmessage, failures.howmuch[ 1 ] );
	}
	
	function testGetFailureMessagesByFieldReturnFrenchWheFrenchLocalePassed()
	{
		instance.i18n.setfwlocale( "fr_FR" );
		var user = EntityNew( "User" );
		var rbmessage = instance.i18n.getResource( "HowMuchRequired" );
		var vtresult = instance.validatethis.validate( User );
		var failures = vtresult.getFailureMessagesByField( locale="fr_FR", limit=1 );
		
		// assert
		assertEquals( rbmessage, failures.howmuch[ 1 ] );
	}
	
	/*
	-----------------------------------------------------------
	getFailuresByProperty tests
	-----------------------------------------------------------
	*/
	function testGetFailuresByPropertyReturnDefaultLocaleWhenNoLocalePassed()
	{
		var user = EntityNew( "User" );
		var rbmessage = instance.i18n.getResource( "HowMuchRequired" );
		var vtresult = instance.validatethis.validate( User );
		var failures = vtresult.getFailuresByProperty( limit=1 );
		
		// assert
		assertEquals( rbmessage, failures.howmuch[ 1 ].message );
	}
	
	function testGetFailuresByPropertyReturnEnglishWhenEnglishLocalePassed()
	{
		var user = EntityNew( "User" );
		var rbmessage = instance.i18n.getResource( "HowMuchRequired" );
		var vtresult = instance.validatethis.validate( User );
		var failures = vtresult.getFailuresByProperty( locale="en_GB", limit=1 );
		
		// assert
		assertEquals( rbmessage, failures.howmuch[ 1 ].message );
	}
	
	function testGetFailuresByPropertyReturnFrenchWhenFrenchLocalePassed()
	{
		instance.i18n.setfwlocale( "fr_FR" );
		var user = EntityNew( "User" );
		var rbmessage = instance.i18n.getResource( "HowMuchRequired" );
		var vtresult = instance.validatethis.validate( User );
		var failures = vtresult.getFailuresByProperty( locale="fr_FR", limit=1 );
		
		// assert
		assertEquals( rbmessage, failures.howmuch[ 1 ].message );
	}
	
	/*
	-----------------------------------------------------------
	getFailureMessagesByProperty tests
	-----------------------------------------------------------
	*/
	function testGetFailureMessagesByPropertyReturnDefaultLocaleWhenNoLocalePassed()
	{
		var user = EntityNew( "User" );
		var rbmessage = instance.i18n.getResource( "HowMuchRequired" );
		var vtresult = instance.validatethis.validate( User );
		var failures = vtresult.getFailureMessagesByProperty( limit=1 );
		
		// assert
		assertEquals( rbmessage, failures.howmuch[ 1 ] );
	}

	function testGetFailureMessagesByPropertyEnglishLocaleWhenEnglishLocalePassed()
	{
		var user = EntityNew( "User" );
		var rbmessage = instance.i18n.getResource( "HowMuchRequired" );
		var vtresult = instance.validatethis.validate( User );
		var failures = vtresult.getFailureMessagesByProperty( locale="en_GB", limit=1 );
		
		// assert
		assertEquals( rbmessage, failures.howmuch[ 1 ] );
	}
	
	function testGetFailureMessagesByPropertyReturnFrenchLocaleWhenFrenchLocalePassed()
	{
		instance.i18n.setfwlocale( "fr_FR" );
		var user = EntityNew( "User" );
		var rbmessage = instance.i18n.getResource( "HowMuchRequired" );
		var vtresult = instance.validatethis.validate( User );
		var failures = vtresult.getFailureMessagesByProperty( locale="fr_FR", limit=1 );
		
		// assert
		assertEquals( rbmessage, failures.howmuch[ 1 ] );
	}
	
	/*
	-----------------------------------------------------------
	getFailuresForUniForm tests
	-----------------------------------------------------------
	*/
	function testGetFailuresForUniFormReturnDefaultLocaleWhenNoLocalePassed()
	{
		var user = EntityNew( "User" );
		var rbmessage = instance.i18n.getResource( "HowMuchRequired" );
		var vtresult = instance.validatethis.validate( User );
		var failures = vtresult.getFailuresForUniForm( limit=1 );
		
		// assert
		assertEquals( rbmessage, ReReplace( failures.howmuch, "<br />.*", "" ) );
	}
	
	function testGetFailuresForUniFormReturnEnglishLocaleWhenEnglishLocalePassed()
	{
		var user = EntityNew( "User" );
		var rbmessage = instance.i18n.getResource( "HowMuchRequired" );
		var vtresult = instance.validatethis.validate( User );
		var failures = vtresult.getFailuresForUniForm( locale="en_GB", limit=1 );
		
		// assert
		assertEquals( rbmessage, ReReplace( failures.howmuch, "<br />.*", "" ) );
	}
	
	function testGetFailuresForUniFormReturnFrenchLocaleWhenFrenchLocalePassed()
	{
		instance.i18n.setfwlocale( "fr_FR" );
		var user = EntityNew( "User" );
		var rbmessage = instance.i18n.getResource( "HowMuchRequired" );
		var vtresult = instance.validatethis.validate( User );
		var failures = vtresult.getFailuresForUniForm( locale="fr_FR", limit=1 );
		
		// assert
		assertEquals( rbmessage, ReReplace( failures.howmuch, "<br />.*", "" ) );
	}
	
	/*
	-----------------------------------------------------------
	getErrors tests
	-----------------------------------------------------------
	*/
	function testGetErrorsReturnDefaultLocaleWhenNoLocalePassed()
	{
		var user = EntityNew( "User" );
		var vtresult = instance.validatethis.validate( User );
		var failures = vtresult.getErrors();
		var rbmessage = instance.i18n.getResource( "HowMuchRequired" );
		
		// assert
		assertEquals( rbmessage, failures.howmuch[ 1 ] );
	}
	
	function testGetErrorsReturnEnglishLocaleWhenoEnglishLocalePassed()
	{
		var user = EntityNew( "User" );
		var vtresult = instance.validatethis.validate( User );
		var failures = vtresult.getErrors( locale="en_GB" );
		var rbmessage = instance.i18n.getResource( "HowMuchRequired" );
		
		// assert
		assertEquals( rbmessage, failures.howmuch[ 1 ] );
	}
	
	function testGetErrorsReturnFrenchLocaleWhenFrenchLocalePassed()
	{
		instance.i18n.setfwlocale( "fr_FR" );
		var user = EntityNew( "User" );
		var vtresult = instance.validatethis.validate( User );
		var failures = vtresult.getErrors( locale="fr_FR" );
		var rbmessage = instance.i18n.getResource( "HowMuchRequired" );
		
		// assert
		assertEquals( rbmessage, failures.howmuch[ 1 ] );
	}
	
	/*
	-----------------------------------------------------------
	getFailuresAsStruct tests
	-----------------------------------------------------------
	*/
	function testGetFailuresAsStructReturnDefaultLocaleWhenNoLocalePassed()
	{
		var user = EntityNew( "User" );
		var vtresult = instance.validatethis.validate( User );
		var rbmessage = instance.i18n.getResource( "UserGroupRequired" );
		var failures = vtresult.getFailuresAsStruct();

		// assert
		assertEquals( rbmessage, failures.usergroupid );
	}		
	
	function testGetFailuresAsStructReturnEnglishLocaleWhenEnglishLocalePassed()
	{
		var user = EntityNew( "User" );
		var vtresult = instance.validatethis.validate( User );
		var rbmessage = instance.i18n.getResource( "UserGroupRequired" );
		var failures = vtresult.getFailuresAsStruct( locale="en_GB" );

		// assert
		assertEquals( rbmessage, failures.usergroupid );
	}		

	function testGetFailuresAsStructReturnFrenchLocaleWhenFrenchLocalePassed()
	{
		instance.i18n.setfwlocale( "fr_FR" );
		var user = EntityNew( "User" );
		var vtresult = instance.validatethis.validate( User );
		var rbmessage = instance.i18n.getResource( "UserGroupRequired" );
		var failures = vtresult.getFailuresAsStruct( locale="fr_FR" );

		// assert
		assertEquals( rbmessage, failures.usergroupid );
	}
	
}