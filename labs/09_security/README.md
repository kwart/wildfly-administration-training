# Lab - JBoss EAP - Security

## Task 1: Deploy secured web application

**What:** Build and deploy application with BASIC authentication

**How:**

* Find the application under `~/wildfly-administration-training/applications/secured`. Build it with Maven (`mvn install`)
and copy resulting WAR to JBoss's `standalone/deployments` directory.
  * review `src/main/webapp/WEB-INF/web.xml` deployment descriptor to see security settings
* Use the `add-user.sh` script to add a new user:
  * username: admin
  * password: admin
  * group: Admin
* check if application is running on http://localhost:8080/secured/
* verify you can login into the application with the `admin` credentials


## Task 2: Configure LDAP authentication:

**What:** Change the application to authenticate against a corporate LDAP server

**How:**
We will use simple LDAP server to emulate corporate environment
and configure WildFly to use it for authentication to the `secured`
application.

* Start LDAP server
```
java -jar /home/student/wildfly-labs-resources/ldap-server.jar
```
* Use JBoss CLI to create a new
[LDAP realm](https://docs.wildfly.org/20/WildFly_Elytron_Security.html#configure-authentication-with-an-ldap-based-identity-store)
in Elytron configuration and Undertow mapping.
Let's use name `training` for relevant objects:

```
/subsystem=elytron/dir-context=training:add( \
  url="ldap://my-server.my-company.example:10389", \
  principal="uid=admin,ou=system",credential-reference={clear-text="secret"})
/subsystem=elytron/ldap-realm=training:add( \
  dir-context=training, \
  identity-mapping={ \
    search-base-dn="ou=Users,dc=jboss,dc=org", \
    rdn-identifier="uid", \
    user-password-mapper={from="userPassword"}, \
    attribute-mapping=[{filter-base-dn="ou=Roles,dc=jboss,dc=org", \
    filter="(&(objectClass=groupOfNames)(member={1}))",from="cn",to="Roles"}]})
/subsystem=elytron/simple-role-decoder=training:add(attribute=Roles)
/subsystem=elytron/security-domain=training:add( \
  realms=[{realm=training,role-decoder=training}],default-realm=training,permission-mapper=default-permission-mapper)
/subsystem=elytron/http-authentication-factory=training:add( \
  http-server-mechanism-factory=global, \
  security-domain=training, \
  mechanism-configurations=[{mechanism-name=BASIC, \
    mechanism-realm-configurations=[{realm-name=training}]}])
/subsystem=undertow/application-security-domain=training:add(http-authentication-factory=training)
  
reload
```

* To use non-default security domain, you have to specify the domain name
  in deployment JBoss specific deployment descriptor.
  Create a new file `src/main/webapp/WEB-INF/jboss-web.xml` with content:
```xml
<jboss-web>
    <security-domain>training</security-domain>
</jboss-web>
```

* rebuild the project with Maven and deploy the new WAR file.
* check you can't login anymore with `admin`/`admin`
* check you can login with LDAP account `jduke`/`theduke`
