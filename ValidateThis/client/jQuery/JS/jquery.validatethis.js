/*
 * jQuery validatethis plug-in 0.98.2
 *
 * Copyright (c) 2011 Adam Drew
 *
  * Dual licensed under the MIT and GPL licenses:
 *   http://www.opensource.org/licenses/mit-license.php
 *   http://www.gnu.org/licenses/gpl.html
 */

// closure for validatethis
(function($){
	$.validatethis = {
		version: '0.98.2',
		settings: {},
		// ValidateThis Settings
		defaults: {
			
			// Plugin Defaults
			debug:				false,
			initialized:		false,
			remoteEnabled:		false,
			
			// Path Defaults
			baseURL: 			'',
			ajaxProxyURL:		'/vtadmin/remote/majik.cfc?method=',
			PluginsFolder:		"/shared/jquery/plugins/forms/",
			
			// CSS Defaults
			ignoreClass:		".ignore",
			errorClass:			'ui-state-error'
		},
		
		result: {
			isSuccess:true,
			errors:[]
		},
		
		init : function(options){
			if (!this.settings.initialized){
				// Log Options For Debugging
				this.log("ValidateThis [options]: " + $.param(options));

				this.session = {};
				var extendedDefaultOptions = $.extend({}, this.defaults, options);
				this.settings = extendedDefaultOptions;
				this.remoteCall("getValidationVersion",{},this.getValidationVersionCallback);
				this.log("ValidateThis [plugin]: v" + this.version);

				this.scriptSetup();
				this.setValidatorDefaults();

				this.settings.initialized = true;
			} else {
				this.log("ValidateThis [plugin]: initialized");
			}
		},
		
		scriptSetup: function(jslib, locale, format){
			//this.log("initializing jQuery & validation plugins");
			//$.getScript(this.settings.PluginsFolder + "jquery.validate.pack.js",this.validatorConfigureCallback);
			//$.getScript(this.settings.PluginsFolder + "jquery.field.min.js", function(){});   
			//$.getScript(this.settings.PluginsFolder + "jquery.form.js", function(){});
			//if (locale){
			//	$.getScript(this.settings.PluginsFolder + "i18n/messages_" + locale + ".js",function(){});
			//}
		},
		
		setValidatorDefaults: function(){
			$.validator.setDefaults({
				errorClass: $.validatethis.settings.errorClass,
				errorElement: 'div',
				errorPlacement: function(error, element) { error.appendTo( element.parent("div"))}
			});
		},
		
		clearFormRules: function(form){
			form.find(":input").each(function(input){
				$(input).rules("remove");
			});
		},
		
		remoteCall: function(action, arguments, callback){
			this.log("ValidateThis [remote]: " + action + " " + $.param(arguments));
			$.get(this.settings.ajaxProxyURL + action + "&" + $.param(arguments), callback);
		},
		remoteCallback: function(data){
			this.log("ValidateThis [remote]: callback-recieved" + $.param(data));
			$("#VT").stop().html(data);
			$("#VT").validatethis({refresh:true});
			$("#VT").fadeIn();
			this.loading(false);
		},

		addMethod: function(methodName,functionScript,message){
			if (!$.validator.methods[methodName]){
				$.validator.addMethod(methodName,functionScript,message);
				this.log("method '" + methodName + "' was added to the jQuery validator. ");
			} else {
				this.log("method '" + methodName + "' already exists. ");
			};
		},
		
		submitHandler: function(form) {
			$.validatethis.log("ValidateThis [form]: submitHandler form " + $(form).attr("name"));
			if ($.validatethis.settings.remoteEnabled){
				$(form).ajaxSubmit({success:$.validatethis.ajaxSubmitSuccessCallback});
			} else {
				form.submit();
			}
		},
		ajaxSubmitSuccessCallback: function(data){
			$.validatethis.log("ValidateThis [remote]: Submit Success. Returned View Data");
		},

		loadRules: function(form,data){
			$.validatethis.log("ValidateThis [validate]: " + form.attr('name') + " = " + data);
			var validations = $.parseJSON(data);
			form.validate({
				debug: false,
				ignore: $.validatethis.settings.ignoreClass,
				submitHandler: $.validatethis.submitHandler,
				rules: validations.rules,
				messages: validations.messages
			});
			
			$.validatethis.log("ValidateThis [status]: ready.");
		},
	
		addRule: function(form,rule){
			var newRule = {};
			var valType = rule.VALTYPE.toLowerCase();
			var result = false;
			var selector = ":input[name='" + rule.CLIENTFIELDNAME + "']";

			newRule[valType] = true;

			if (!$.isEmptyObject(rule.Parameters)){
				newRule[valType] = rule.Parameters;
			}

			if (rule.FAILUREMESSAGE.length){
				newRule["messages"] = {};
				newRule["messages"][valType] = rule.FAILUREMESSAGE;
			}

			if ($(selector,form).length) {
				var clientField = $(selector,form);
				clientField.rules("add",newRule);
				result = true;
				this.log("ADDED PROPERTY RULE FOR " + rule.PROPERTYDESC + " (" + rule.CLIENTFIELDNAME + ") : " + valType + " " + rule.FAILUREMESSAGE);
			}
		},

		getValidationVersionCallback: function(data){
			$.validatethis.settings.remoteEnabled = true;
			$.validatethis.log("ValidateThis [remote]: v" + data);
		},

		getScriptCallback: function(data){
			this.log("getScriptCallback:recieved" + $.param(data));
			this.loading(false);
		},

		validatorConfigureCallback: function(data){
			this.setValidatorDefaults();
		},

		action: function(form,command,parameters,callback){
			var action = command.split(":");
			var serviceName = action[0];
			var methodName = action[1];
			var entityName = parameters[0];
			var id = parameters[1];
			var args = {command:command,entityName:entityName,id:id};
			this.loading(true);
			this.remoteCall("action",args,this.remoteCallback);
		},

		getScript: function(property, scriptTarget){
			var arguments = {
				params: {}
			};
			this.log("ValidateThis [rules]: property=" + property);		
			this.remoteCall('getScript', arguments, this.getScriptCallback);
		},

		loading: function(enabled){
			if (enabled == true) {
				$("#VT").stop().hide();
				$("#VTLoader").show();
			} else {
				$("#VT").stop().hide();
			};
		},

		getRules: function(form){
			var count = 0;
			form.find(":input").each(function(){
				var $this = $(this);
				var valid = false;
				var propertyName = $this.attr("name");
				if (propertyName == '' || propertyName.match('^_')){
					$.validatethis.log("exclude validations for " + form.attr('name') + '.' + propertyName);
				} else {
					$.validatethis.log("include validations for " + form.attr('name') + '.' + propertyName);
					try {
						valid = form.valid();					
						formRules = $(this).rules();
						$.validatethis.log("ValidateThis [rules]: " + $(this).attr("name") + " " + $.param(formRules));
						return formRules;
					} catch (x){ $.validatethis.log("error: " + x); }
				};
			});
		},

		log: function(message){
			if (this.settings.debug && window.console) {
				if (console.debug){
					console.debug(message);
				} else if (console.log){
					console.log(message);
				}
			}
			else {
				// log to some other mechanism here (alert? ajax? ui?)
				// alert(message);
			};
		}
	};

	// Plugin Methods
	$.fn.validatethis = function(options){	
		// iterate and reformat each matched element
		var opts = $.extend({}, $.validatethis.settings, options);
		return this.each(function(){
			// build element specific options
			var o = $.meta ? $.extend({}, opts, $this.data()) : opts;
				$.validatethis.init(o);	
				// Initialize Validate Plugin
				$(this).find("form").each(function(){
					var $form = $(this);
					$.validatethis.log("ValidateThis [form]: " + $form.attr('name'));
					$.validatethis.remoteCall("getValidationJSON",{"objectType":"system","formName":"","locale":"","context":""},
						function(data){
							$.validatethis.loadRules($form,data);
						}
					);
				});
		});
	};

// end of closure
})(jQuery);