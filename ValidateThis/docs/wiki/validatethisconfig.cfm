== ValidateThisConfig Struct ==

The framework is configured via a structure referred to as the ValidateThisConfig Struct.  Each key has a default value in the framework, so if the default values match with your requirements you need not specify any keys. In that case you don't even have to define a ValidateThisConfig struct, as you can create the [[ValidateThis Facade Object]] without passing in a ValidateThisConfig struct.

The struct is composed of the following keys:

=== definitionPath ===
This key specifies the location of your [[Rules Definition File | rules definition files]], one for each Business Object for which you want the framework to generate validations. By default it points to the ''/model/'' folder.

=== JSRoot ===
The framework can be asked to generate all of the JavaScript statements necessary to load and configure all of the JS libraries required for client-side validations. This key specifies where the JavaScript files can be found on your web server. By default the location is ''/JS/''. If you are going to use this feature and your JS files are located elsewhere, you will need to specify that value using this key.

=== defaultFormName ===
This key specifies the default form name/id to be used when generating client-side validations. By default the form name is ''frmMain''. This is provided for convenience as it is easily overridable on a case by case basis. More information on specifying the form name for your client-side validations is available at [[Generating Client-Side Validations]].

=== defaultJSLib ===
This key specifies which JavaScript implementation should be used for generating client-side validations. By default it specifies the ''jQuery Validation Plugin'', which is the only JavaScript implementation that currently ships with the framework. Because ValidateThis can be configured with support for multiple JavaScript implementations, this key allows a developer to switch implementations globally. Because there is currently only one JS implementation, there should currently be no need to specify this key.

Note that this is referred to as a ''Default'' JSLib because the framework allows you to override this value on a case-by-case basis, effectively allowing you to use multiple JS implementations in a single application.

=== BOValidatorPath ===
This key specifies the path to the BOValidator component, which acts as a facade between your business object and the framework.  By default it points to the framework's own BOValidator.cfc.  It is possible that advanced users may want to either extend or override that component with their own version, and this key allows for that. Therefore there is little chance that a developer will need to specify this key.

=== Internationalization Keys ===
The following keys are used to configure the Internationalization (i18n) behaviour of the framework. If you are using the framework with a single language you can safely leave them out of your ValidateThisConfig struct.  More information about i18n is available at [[Internationalization with ValidateThis]].

==== TranslatorPath ====
This key specifies the path to the Translator component, which is used to translate validation failure messages.  By default it points to the framework's BaseTranslator.cfc, which doesn't actually translate anything.  Therefore, unless you need to support multiple languages this key does not need to be specified.

==== LocaleLoaderPath ====
This key specifies the path to the LocaleLoader component, which is used to load information about various language translations into the Translator. By default it points to the framework's BaseLocaleLoader.cfc, which doesn't load anything.  Again, unless you need to support multiple languages this key does not need to be specified.

==== localeMap ====
This key provides a struct which contains information about which locales the application is to support, and their corresponding resource bundle property files. By default it is an empty struct, so, unless you need to support multiple languages this key does not need to be specified.

==== defaultLocale ====
This key specifies the default locale that will be used by the framework if none is passed to method calls. By default it has the value of ''en_US'', which is English. Even if the single language you are supporting is not English, unless you need to support multiple languages this key does not need to be specified.

