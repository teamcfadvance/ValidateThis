component
	output="false"
	name="ClientRuleScripter_Accept"
	extends="AbstractClientRuleScripter"
	hint="I am responsible for generating JS code for the accepts validation."
{

	public any function getRuleDef(
		required any validation hint="The validation object that describes the validation.",
		required any parameters hint="The parameters stored in the validation object."
	)
		hint="I return just the rule definition which is required for the generateAddRule method."
	{
		var parameterDef = getParameterDef(arguments.validation);
		if ( arguments.validation.hasParameter("accept") ) {
			var ruleDef = '"#getValType()#":"#arguments.validation.getParameterValue("accept")#"';
		}
		return ruleDef;
	}

}