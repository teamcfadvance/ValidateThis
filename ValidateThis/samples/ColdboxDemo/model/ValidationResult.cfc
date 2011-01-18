/**
 * I am a specialised version of the default ValidateThis result object to show you what is possible
 * Using your own ValidationResult object is entirely optional
 */
component extends="ValidateThis.util.Result" 
{
	string function renderErrorByField( required string fieldname )
	{
		var result = "";
		var failureCollection = getFailuresForUniform();
		var error = "";
		if ( StructKeyExists( failureCollection, arguments.fieldname ) )
		{
			result = '<p id="error-UserName" class="errorField bold">' & failureCollection[ arguments.fieldname ] & '</p>';
		}
		return result;
	}
}
