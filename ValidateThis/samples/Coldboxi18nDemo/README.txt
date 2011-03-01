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

This demo uses the ValidateThisCB3Plugin.cfc ColdBox plugin which is available in the extras directory of the download. All the 
configuration of ValidateThis is done in the config/Coldbox.cfc file. Using the plugin makes integration with ValidateThis easy, 
however you can still use ValidateThis via a beanfactory such as ColdSpring if you prefer.

If you are using ColdBox 2.6, then you will need to use the ValidateThisCB3Plugin.cfc ColdBox plugin.

If you have any questions then please post them to the ValidateThis google group at: http://groups.google.com/group/validatethis
