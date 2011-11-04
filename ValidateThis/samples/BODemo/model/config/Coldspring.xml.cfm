<!DOCTYPE beans PUBLIC "-//SPRING//DTD BEAN//EN" "http://www.springframework.org/dtd/spring-beans.dtd">

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
 
<beans default-autowire="byName">

	<!-- ValidateThis Service Object -->
	<bean id="ValidateThis" class="ValidateThis.ValidateThis">
		<constructor-arg name="ValidateThisConfig"><ref bean="ValidateThisConfig" /></constructor-arg>
	</bean>
		
	<!-- ValidateThis Config Bean -->
	<bean id="ValidateThisConfig" class="coldspring.beans.factory.config.MapFactoryBean">
		<property name="sourceMap">
			<map>
				<entry key="BOValidatorPath"><value>BOValidator</value></entry>
				<entry key="DefaultJSLib"><value>jQuery</value></entry>
				<entry key="defaultFormName"><value>frmMain</value></entry>
			</map>
		</property>
	</bean>

	<!-- Transfer beans-->
      
	<bean id="transferFactory" class="transfer.TransferFactory">
		<constructor-arg name="datasourcePath"><value>/validatethis/samples/BODemo/model/config/datasource.xml.cfm</value></constructor-arg>
		<constructor-arg name="configPath"><value>/validatethis/samples/BODemo/model/config/transfer.xml.cfm</value></constructor-arg>
		<constructor-arg name="definitionPath"><value>/validatethis/samples/BODemo/TransferTemp</value></constructor-arg>
	</bean>

	<bean id="transfer" factory-bean="transferFactory" factory-method="getTransfer" />
	
	<bean id="TDOBeanInjectorObserver" class="ValidateThis.util.TDOBeanInjectorObserver" lazy-init="false">
		<constructor-arg name="transfer"><ref bean="transfer" /></constructor-arg>
		<constructor-arg name="afterCreateMethod"><value>Setup</value></constructor-arg>
		<property name="beanInjector">
			<ref bean="beanInjector" />
		</property>
	</bean>

	<bean id="beanInjector" class="ValidateThis.util.BeanInjector">
		<constructor-arg name="debugMode"><value>false</value></constructor-arg>
	</bean>
		
	<!-- Gateway beans -->
	
	<bean id="GatewayMap" class="coldspring.beans.factory.config.MapFactoryBean">
		<property name="sourceMap">
			<map>
				<entry key="User">
					<ref bean="UserGateway" />
				</entry>
			</map>
		</property>
	</bean>

	<bean id="UserGateway" class="validatethis.samples.BODemo.model.Gateway.userGateway">
	</bean>

	<!-- Service beans -->
	
	<bean id="UserService" class="validatethis.samples.BODemo.model.service.UserService">
		<property name="GatewayMap">
			<ref bean="GatewayMap" />
		</property>
	</bean>
	
</beans>
