jQuery(document).ready(function($) {
	jQuery.validator.setDefaults({ 
		errorClass: 'errorField', 
		errorElement: 'p', 
		errorPlacement: function(error, element) { 
			error.prependTo( element.parents('div.ctrlHolder') ) 
		}, 
		highlight: function() {}
	});
});
