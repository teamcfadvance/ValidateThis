<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="http://www.validatethis.org/validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<conditions>
		<condition name="MustLikeSomething" 
			serverTest="getLikeCheese() EQ 0 AND getLikeChocolate() EQ 0"
			clientTest="$(&quot;[name='LikeCheese']&quot;).getValue() == 0 &amp;&amp; $(&quot;[name='LikeChocolate']&quot;).getValue() == 0;" />
	</conditions>
	<contexts>
		<context name="Register" formName="frmMain" />
		<context name="Profile" formName="frmMain" />
	</contexts>
	<objectProperties>
		<property name="UserName">
			<!-- note: the failure message matches the resource bundle key -->
			<rule type="required" contexts="*" failureMessage="EmailRequired" />
			<rule type="email" contexts="*" failureMessage="NotEmail" />
		</property>
		<property name="Nickname">
			<rule type="custom" failureMessage="NicknameTaken"> <!-- Specifying no context is the same as specifying a context of "*" -->
				<param name="methodname" value="CheckDupNickname" />
				<param name="remoteURL" value="ColdBoxProxy.cfc?method=CheckDupNickname&amp;returnformat=plain" />
			</rule>
		</property>
		<property name="UserPass">
			<rule type="required" contexts="*" failureMessage="UserPassRequired" />
			<rule type="rangelength" contexts="*" failureMessage="UserPassRangeLength">
				<param name="minlength" value="5" />
				<param name="maxlength" value="10" />
			</rule>
		</property>
		<property name="VerifyPassword">
			<rule type="required" contexts="*" failureMessage="VerifyPasswordRequired" />
			<rule type="equalTo" contexts="*" failureMessage="VerifyPasswordEqualTo">
				<param name="ComparePropertyName" value="UserPass" />
			</rule>
		</property>
		<property name="UserGroup" clientfieldname="UserGroupId">
			<rule type="required" contexts="*" failureMessage="UserGroupRequired" />
		</property>
		<property name="Salutation">
			<rule type="required" contexts="Profile" failureMessage="SalutationRequired" />
			<rule type="regex" contexts="*" failureMessage="SalutationRegex">
				<param name="Regex" value="^(Dr|Prof|Mr|Mrs|Ms|Miss)(\.)?$" />
			</rule>
		</property>
		<property name="FirstName">
			<rule type="required" contexts="Profile" failureMessage="FirstNameRequired" />
		</property>
		<property name="LastName">
			<rule type="required" contexts="Profile" failureMessage="LastNameRequiredProfile" />
			<rule type="required" contexts="Register" failureMessage="LastNameRequiredRegister">
				<param name="DependentPropertyName" value="FirstName" />
			</rule>
		</property>
		<property name="LikeOther">
			<rule type="required" contexts="*" condition="MustLikeSomething"
				failureMessage="MustLikeOther">
			</rule>
		</property>
		<property name="HowMuch">
			<rule type="required" contexts="*" failureMessage="HowMuchRequired" />
			<rule type="numeric" contexts="*" failureMessage="HowMuchNumeric" />
		</property>
		<property name="CommunicationMethod">
			<rule type="required" contexts="*"
				failureMessage="CommunicationMethodRequired">
				<param name="DependentPropertyName" value="AllowCommunication" />
				<param name="DependentPropertyValue" value="1" />
			</rule>
		</property>
	</objectProperties>
</validateThis>
