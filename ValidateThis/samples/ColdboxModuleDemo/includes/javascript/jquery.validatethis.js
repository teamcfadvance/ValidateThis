/*
 * WIP jQuery.validatethis.js plug-in for ValidateThis 0.98.3+
 * Created 2011 Adam Drew
 *
 */

// closure for plugin
(function($){
	$.validatethis = {
		version: '0.98.2',
		ruleCache: {}, // todo: client side rule caching
		
		// Settings
		settings: {}, 
		defaults: {
			debug:				false,
			initialized:		false,
			remoteEnabled:		false,
			baseURL: 			'',
			appMapping:			'',
			ajaxProxyURL:		'/remote/validatethisproxy.cfc?method=',
			ignoreClass:		".ignore",
			errorClass:			'ui-state-error'
		},
		
		result: {
			isSuccess:true,
			errors:[]
		},
		
		init : function(options){
			if (!this.settings.initialized){
				this.session = {};
				
				this.log("ValidateThis [plugin]: initializing v" + this.version);
				
				// Log Options For Debugging
				this.log("ValidateThis [options]: " + $.param(options));
				
				var extendedDefaultOptions = $.extend({}, this.defaults, options);
				
				this.settings = extendedDefaultOptions;

				// See: : /validatethis/extras/coldbox/remote/validatethisproxy.cfc
				this.remoteCall("getValidationVersion",{},this.getVersionCallback);
				$.validatethis.remoteCall("getInitializationScript",{},
						function(data){
							$.validatethis.evalInitScript(data);
						}
				);
				
				this.setValidatorDefaults();
				this.settings.initialized = true;
				
			} else {
				this.log("ValidateThis [plugin]: initialized");
			}
		},
		
		setValidatorDefaults: function(){
			$.validator.setDefaults({
				errorClass: $.validatethis.settings.errorClass,
				errorElement: 'span',
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
		
		evalInitScript : function(data){
			var dataEl = $(data);
			eval(dataEl.html());
		},
		
		getVersionCallback: function(data){
			$.validatethis.settings.remoteEnabled = true;
			$.validatethis.log("ValidateThis [remote]: v" + data);
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
					$.validatethis.remoteCall("getValidationJSON",{"objectType":$form.attr('rel'),"formName":$form.attr('name'),"locale":"","context":""},
						function(data){
							$.validatethis.loadRules($form,data);
						}
					);
				});
		});
	};

// end of closure
})(jQuery);