/**
 * I am the ColdBox proxy used for remote calls
 */
component extends="coldbox.system.remote.ColdboxProxy"
{

	remote any function checkDupNickname( required string nickname )
	{
		// note: result must be quoted as javascript is case sensitive
		var result = "true";
		
		// in real code you'd call the service layer or use process()
		if ( arguments.nickname == "BobRules" )
		{
			result = "false";
		}
		return result;
	}

}
