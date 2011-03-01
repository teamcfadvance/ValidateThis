component extends="approot.test.BaseTestCase"
{	
	
	function setup()
	{
		//Call the super setup method to setup the app.
		super.setup();
	}

	function testChangeLocaleGB()
	{
		var event = "";
		
		URL.locale = 'en_GB';
		
		// Execute Event
		event = execute( "general.changelocale" );
		
		// assert
		assertTrue( getPlugin( "i18n" ).getfwLocale() == URL.locale );
	}

	function testChangeLocaleFR()
	{
		var event = "";
		
		URL.locale = 'fr_FR';
		
		// Execute Event
		event = execute( "general.changelocale" );
		
		// assert
		assertTrue( getPlugin( "i18n" ).getfwLocale() == URL.locale );
	}

	function testIndex()
	{
		var event = "";
		var rc = "";
		
		// Execute Event
		event = execute( "general.index" );
		rc = event.getCollection();
		
		// assert
		assertTrue( isArray( rc.users ) );
	}
	
}
