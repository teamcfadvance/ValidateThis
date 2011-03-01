<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title>ValidateThis - A Validation Framework for ColdFusion Objects</title>
	<link rel="stylesheet" href="css/layout.css" type="text/css" />
	<link rel="stylesheet" href="css/style.css" type="text/css" />
</head>

<body>

<div id="wrap">
	<div id="header">			
		<h1 id="logo-text"><a href="http://www.validatethis.org" title="ValidateThis">ValidateThis</a></h1>		
		<p id="slogan">A Validation Framework for ColdFusion Objects</p>
		<!---
		<div id="header-links">
			<p>
			<a href="http://www.silverwareconsulting.com/contact.cfm">Contact</a> | 
			<a href="http://www.silverwareconsulting.com/rss.cfm?mode=full" rel="noindex,nofollow">RSS</a>
			</p>		
		</div>
		--->
	</div>

	<div id="content-wrap">
				
		<div id="main">
				
			<div class="entry">
				<h2>Welcome to the home of ValidateThis</h2>
		
				<p>
					ValidateThis is a framework that allows you to define validation rules for your ColdFusion objects in a single place (either an XML file, a JSON file or in ColdFusion code) and will then generate client-side and server-side validations for you.
				</p>
				<p>Note that as of version 0.96, you can also use ValidateThis to validate a simple structure - you don't need to be working with objects.
					Also note that your metadata can be in the form of JSON as an alternative to XML.</p>
				<p>Please check out one of the demos, linked to the right, to see the framework in action, as well as a sample xml file.</p>
				<p>The framework, as well as all of the demo code, can be downloaded from <a href="http://validatethis.riaforge.org/" title="validatethis.riaforge.org" target="_blank">validatethis.riaforge.org</a>. Near-complete documentation is now available at <a href="/docs/">www.validatethis.org/docs/</a>, and more in-depth discussion can be found at <a href="http://www.silverwareconsulting.com/index.cfm/ValidateThis" target="_blank">my blog</a>.</p>
				<p>The framework itself has been designed to be extremely flexible and extensible. For example:
					<ul>
						<li>The framework ships with a wide variety of built-in validation types. It is easy to add custom validation types without having to touch any existing framework code.</li>
						<li>The framework ships with client-side validations implemented using the jQuery Validation Plugin.  It is possible to add other client-side implementations (e.g., prototype, spry, etc.) without touching any of the existing framework code.</li>
						<li>When validation failures occur the framework will return a suitable and meaningful failure message.  These default failure messages can easily be overriden by an application developer.</li>
						<li>In addition to failure messages, the framework will return metadata about the validation failure, which can be used to further customize the display of failure information to a user.  This can facilitate internationalization.</li>
						<li>The framework can be used in conjunction with any other framework (e.g., Transfer, Reactor, etc.), or no framework at all.  As long as you are using a Business Object, you can use the framework to fulfill your validation needs.</li>
						<li>The framework now supports internationalization (i18n).</li>
					</ul>
				</p>
   
			</div>
		
		</div>
		
		<div id="sidebar">
	
			<h3>Download</h3>
	
			<ul class="sidemenu">
				<li>
					You can download the most recent version of ValidateThis from <a href="http://validatethis.riaforge.org/" title="validatethis.riaforge.org" target="_blank">validatethis.riaforge.org</a>.
				</li>
				
			</ul>
			
			<h3>Demo</h3>
	
			<ul class="sidemenu">
				<li>
					<a href="FacadeDemo/index.cfm">Client and Server-Side Validations</a>
				</li>
				<!---
				<li>
					<a href="i18nDemo/index.cfm">Internationalization (i18n) Demo</a>
				</li>
				--->
			</ul>
			
			<h3>Documentation</h3>
	
			<ul class="sidemenu">
				<li>Near-complete documentation for the framework is now available at <a href="http://www.validatethis.org/docs/">www.validatethis.org/docs/</a>.</li>
				<li>JavaDoc style API documentation (thanks to <a href="http://colddoc.riaforge.org/" target="_blank">ColdDoc</a>) is now available at <a href="http://www.validatethis.org/docs/api/">www.validatethis.org/docs/api</a>.</li>
				<li>Numerous postings can be found on <a href="http://www.silverwareconsulting.com/index.cfm/ValidateThis" target="_blank">my blog</a>.</li>
				<li>There is also a <a href="http://groups.google.com/group/validatethis" target="_blank">Google Group</a> available for questions and discussion.</li>
			</ul>
			
			<h3>Contributors</h3>
	
			Contributors to ValidateThis include:
			<ul class="sidemenu">
				<li><a href="http://adamdrew.me/blog/" target="_blank">Adam Drew</a></li>
				<li><a href="http://www.aliaspooryorik.com/blog/" target="_blank">John Whish</a></li>
				<li>TJ Downes</li>
				<li><a href="http://jamiekrug.com/blog/" target="_blank">Jamie Krug</a></li>
				<li><a href="http://blog.mxunit.org/" target="_blank">Marc Esher</a></li>
				<li><a href="http://chris.m0nk3y.net/" target="_blank">Chris Blackwell</a></li>
			</ul>
			
			<h3>Presentations</h3>
	
			<ul class="sidemenu">				
				<li>An Object Oriented Approach to Validations
					<ul>
						<li>
							<a href="http://www.silverwareconsulting.com/index.cfm/2009/5/19/An-Object-Oriented-Approach-to-Validations--Presentation-Materials-Available" target="_blank">Slide Deck</a>
						</li>
					</ul>
				</li>
			</ul>
			
		</div>
	
	</div>
		
		
	<!-- footer starts -->		
	<div id="footer-wrap">
		<div id="footer-bottom">
			&copy; <cfoutput>#year(now())#</cfoutput> <strong>Bob Silverberg</strong> | 
			Design by: <a href="http://www.styleshout.com/">styleshout</a>
		</div>
	<!-- footer ends-->
	</div>

<!-- wrap ends here -->
</div>

</body>
</html>
