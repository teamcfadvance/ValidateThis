<?xml version="1.0" encoding="UTF-8"?>

<!--
	
	Copyright 2008, Bob Silverberg
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
-->

<transfer xsi:noNamespaceSchemaLocation="transfer.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

	<objectDefinitions>
		<package name="user">
			<object name="user" table="tblUser" decorator="validatethis.samples.BODemo.model.user">
				<id name="UserId" type="numeric" />
				<property name="UserName" type="string" />
				<property name="UserPass" type="string" />
				<property name="Nickname" type="string" />
				<property name="Salutation" type="string" nullable="true" />
				<property name="FirstName" type="string" nullable="true" />
				<property name="LastName" type="string" nullable="true" />
				<property name="LikeCheese" type="numeric" nullable="true" />
				<property name="LikeChocolate" type="numeric" nullable="true" />
				<property name="LikeOther" type="string" nullable="true" />
				<property name="LastUpdateTimestamp" type="date"  />
				<property name="AllowCommunication" type="numeric" nullable="true" />
				<property name="HowMuch" type="numeric" nullable="true" />
				<property name="CommunicationMethod" type="string" nullable="true" />
	  			<manytoone name="UserGroup">
	  				<link to="user.usergroup" column="UserGroupId"/>
	  			</manytoone>
			</object>
			<object name="usergroup" table="tblUserGroup" decorator="validatethis.samples.BODemo.model.UserGroup">
				<id name="UserGroupId" type="numeric" />
				<property name="UserGroupDesc" type="string" />
			</object>
		</package>
	</objectDefinitions>
</transfer>
