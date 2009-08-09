== Defining Validation Rules ==

There are currently two means of defining the validation rules for your objects.

=== Rules Configuration File ===

My preferred method is to define all of the validation rules for a specific Business Object in an xml file. Among the reasons that I prefer this are:
<ul>
	<li>The definitions of the validation rules are kept separate from the code of the object itself.<br />
		This provides a couple of benefits:
		<ul>
			<li>One can change validation rules without having to open up the object code, which removes the chance of bugs being introduced into the code.</li>
			<li>One can change one's approach to validations for an object (by switching to a different validation framework, for example) without having to make any changes to the object's code.</li>
		</ul>
	</li>
	<li>The xml schema provides a very concise way of describing the validation rules for an object. There is absolutely no duplication of information required.</li>
</ul>

Details of the xml schema for the rules configuration file can be found in the [[Rules Configuration File]] reference.
A sample rules configuration file can be found at [[Sample Rules Configuration File]].

=== The addRule() Method ===

There are times when rules must be added dynamically, and I also understand that some people are xml-averse. For those reasons the framework provides an ''addRule()'' method which enables a developer to define validation rules using CFML code.

The ''addRule()'' method accepts the following arguments:
<ul>
	<li>''propertyName'' The name of the property for which the rule is being defined.</li>
	<li>''valType'' The validation type.</li>
	<li>''clientFieldName (optional)'' The id of the form field that corresponds to the property. Defaults to propertyName.</li>
	<li>''propertyDesc (optional)'' A descriptive name of the property, used in validation failure messages. Defaults to propertyName.</li>
	<li>''condition (optional)'' A structure that contains keys for ''name'', ''serverTest'', ''clientTest (optional)'' and ''desc (optional)''.</li>
	<li>''parameters (optional)'' A structure that contains one key for each parameter.</li>
	<li>''contexts (optional)'' A list of contexts to which the rule should be added.</li>
	<li>''failureMessage (optional)'' A custom message to be displayed on validation failure.</li>
	<li>''formName (optional)'' The name of the form to which the rules applies.</li>
</ul> 

Please see the [[Rules Configuration File | Rules Configuration File reference]] for more details.

=== Future Enhancements ===

The possibility of defining validation rules via &lt;cfproperty&gt; tags is being considered. This is mainly the result of CF9's ORM features making use of the tags.
