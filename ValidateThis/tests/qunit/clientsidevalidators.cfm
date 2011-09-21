<cfsetting enablecfoutputonly="true" showdebugoutput="false">
<cfset ValidateThis = createObject("component","ValidateThis.ValidateThis").init()>
<cfoutput>
<!DOCTYPE html>
<html>
<head>
	<title>QUnit Test Suite</title>
	<link rel="stylesheet" href="qunit/qunit.css" type="text/css" media="screen">
	<script type="text/javascript" src="qunit/qunit.js"></script>
	<!-- Your project file goes here -->
	#ValidateThis.getInitializationScript()#
	<script type="text/javascript">
	jQuery(function($) {
		function methodTest( methodName ) {
			var v = $("##form").validate();
			var method = $.validator.methods[methodName];
			var element = $("##firstname")[0];
			return function(value, param) {
				element.value = value;
				return method.call( v, value, element, param );
			};
		}

		test("boolean", function() {
			var method = methodTest("boolean");
			ok( method(1), '1' );
			ok( method(0), '0' );
			ok( method("1"), '"1"' );
			ok( method("0"), '"0"' );
			ok( method(true), 'true' );
			ok( method(false), 'false' );
			ok( method('true'), '"true"' );
			ok( method('false'), '"false"' );
			ok( method(10), '10' );
			ok( method('10'), '"10"' );
			ok( method('yes'), '"yes"' );
			ok( method('no'), '"no"' );
			ok( method('Yes'), '"Yes"' );
			ok( method('No'), '"No"' );
			ok( method('YES'), '"YES"' );
			ok( method('NO'), '"NO"' );
			ok( !method('not boolean'), "'not boolean'" );
		});
		
		test("DoesNotContainOtherProperties", function() {
			var v = jQuery("##form").validate();
			var method = $.validator.methods["doesnotcontainotherproperties"], 
				param = ['firstname','lastname'],
				e = $("##password")[0];

			//should fail
			$('##lastname, ##firstname').val('abc123');
			jQuery.each(['abc123','xx-abc123','xx-abc123-xx','abc123-xx'],function(index,value){
				ok( !method.call( v, value, e, param ), value );
			});

			//should fail
			$('##lastname').val('');
			jQuery.each(['abc123','xx-abc123','xx-abc123-xx','abc123-xx'],function(index,value){
				ok( !method.call( v, value, e, param ), value );
			});
			
			//should pass
			jQuery.each(['123abc','xyz','','123','abc'],function(index,value){
				ok( method.call( v, value, e, param ), value );
			});			
		});
		
		test("equalTo", function() {
			var v = jQuery("##form").validate();
			var method = $.validator.methods.equalTo,
				e = $('##firstname, ##lastname');
			$('##lastname, ##firstname').val('abc123');
			ok( method.call( v, "abc123", e[0], "##firstname"), "abc123" );
			ok( !method.call( v, "zzz", e[1], "##lastname"), "zzz" );
		});
		
		test("false", function() {
			var method = methodTest("false");
			jQuery.each(['false','0',false,0],function(index,value){
				ok( method(value), value.toString());
			});
			jQuery.each(['true','1',true,1,'vt rocks'],function(index,value){
				ok( !method(value), '!'+value.toString());
			});
		});
		
		test("true", function() {
			var method = methodTest("true");
			jQuery.each(['false','0',false,0,'vt rocks'],function(index,value){
				ok( !method(value), '!'+value.toString());
			});
			jQuery.each(['true','1',true,1],function(index,value){
				ok( method(value), value.toString());
			});
		});
		
		test("futuredate", function() {
			var v = jQuery("##form").validate();
			var method = $.validator.methods["futuredate"], 
				param = {},
				e = $("##firstname")[0];
			
			var today = new Date();
			var tomorrow = today.setDate(today.getDate()+1);
			var yesterday = today.setDate(today.getDate()-1);
			
			//should pass
			jQuery.each([new Date(2100,1,1),tomorrow],function(index,value){
				ok( method.call( v, value, e, param ), value.toString() );
			});
			
			//should fail
			jQuery.each([new Date(2000,1,1),today,yesterday],function(index,value){
				ok( !method.call( v, value, e, param ), "! " + value.toString() );
			});

			var v = jQuery("##form").validate();
			var method = $.validator.methods["futuredate"], 
				param = {after:tomorrow},
				e = $("##firstname")[0];
				
			//should pass
			jQuery.each([new Date(2100,1,1)],function(index,value){
				ok( method.call( v, value, e, param ), value.toString() );
			});
			//should fail
			jQuery.each([new Date(2000,1,1),today,yesterday,tomorrow],function(index,value){
				ok( !method.call( v, value, e, param ), "! " + value.toString() );
			});
		});
		
		test("inlist", function() {
			var v = jQuery("##form").validate();
			var method = $.validator.methods["inlist"], 
				param = {},
				e = $("##firstname")[0];
			/*
			//should pass
			jQuery.each([new Date(2100,1,1),tomorrow],function(index,value){
				ok( method.call( v, value, e, param ), value.toString() );
			});
			
			//should fail
			jQuery.each([new Date(2000,1,1),today,yesterday],function(index,value){
				ok( !method.call( v, value, e, param ), "! " + value.toString() );
			});
			*/
		});
		
		
		test("daterange", function() {
			var v = jQuery("##form").validate();
			var method = $.validator.methods["daterange"], 
				param = {from:'12/29/1968', until:'1/1/1969'},
				e = $("##firstname")[0];

			// should all pass
			jQuery.each(["12/29/1968","1/1/1969","1968/12/29","1968-12-29","12/31/1968","31-Dec-68","December 31, 1968","Dec. 31 1968","12/31/68","31/12/1968","1968-12-31"],function(index,value){
				ok( method.call( v, value, e, param ), value.toString() );
			});
			// should all fail
			jQuery.each(["12/28/1969","1/2/1969","01/02/1969","12/31/1969","2010-12-31","abc",-1],function(index,value){
				ok( !method.call( v, value, e, param ), value.toString() );
			});
			
		});
	});
	</script>
</head>
<body>
	<h1 id="qunit-header">QUnit Test Suite</h1>
	<h2 id="qunit-banner"></h2>
	<div id="qunit-testrunner-toolbar"></div>
	<h2 id="qunit-userAgent"></h2>
	<ol id="qunit-tests"></ol>
	
	<form>
		<input type="text" id="firstname" name="firstname">
		<input type="text" id="lastname" name="lastname">
		<input type="text" id="password" name="password">
	</form>
</body>
</html>
</cfoutput>