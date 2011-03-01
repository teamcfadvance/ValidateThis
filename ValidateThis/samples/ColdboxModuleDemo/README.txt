--------------------------------------------------------
Demo requirements:
--------------------------------------------------------

ColdBox 3 (currently in RC developement phase)
- you can download the latest RC from https://github.com/ColdBox/coldbox-platform

ColdFusion 9.01
- you can download the developer edition from http://www.adobe.com/products/coldfusion/

MySQL or Microsoft SQL Server

--------------------------------------------------------
Demo setup
--------------------------------------------------------

You'll need to run the mssql-setup.sql or mysql-setup.sql scripts to create a database. The SQL scripts are in the samples directory

ColdBox needs to be installed in the webroot or using a mapping

--------------------------------------------------------
Demo notes
--------------------------------------------------------

This demo builds upon John Whish's most excellent ValidateThis ColdboxDemo.

ValidateThis is added to this demo as a new CB3 module, in a way that hopefully provides a re-usable template for other VT+CB3 module implementations.

It uses the ColdboxValidateThisInterceptor that is available in the extras/coldbox directory of the download.

Using the ColdboxValidateThisInterceptor makes integration with ValidateThis very easy, however you can still use ValidateThis via a beanfactory such as ColdSpring, Lightwire, Wirebox, or what have you.

All the configuration of ValidateThis is done in the config/Coldbox.cfc or config/Coldbox.xml.cfm file.



This demo also shows a usage the following custom interception points provided by the interceptor: 
	
	validate
		announces preValidate
		announces postValidate
		
	prepareValidationRequest
		announces getObjectForValidation

This demo also includes shows a working example of the new jQuery ValidateThis plugin provides the streamlined client-side implementation for ValidateThis metadata.
 
If you wish to have remote access to the VT instance created by the the ColdBoxValidateThisInterceptor, you should create a remote proxy cfc in your application that ultimately extends validatethis.extras.coldbox.remote.ValidateThisProxy, which itself extends coldbox.system.remote.ColdboxProxy.

If you have any questions then please post them to the ValidateThis google group at: http://groups.google.com/group/validatethis