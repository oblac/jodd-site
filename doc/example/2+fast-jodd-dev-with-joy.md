# Fast app development with Jodd Joy

<div class="doc1"><js>doc1('example',25)</js></div>
Your time is precious, so lets do a quick roundup of *Jodd* microframeworks.
Instead of configuring and integrating each framework manually, we will use
[*Joy*](/doc/joy/index.html) - an application template that significantly
speeds up the project start-up time and that provides *Jodd* best
practices combined with pragmatic approach in development.

## Init project and IDE

Create common Maven folder structure for web projects:

~~~~~
    /root
        /src
            /main
                /java
                /resources
                /webapp
            /test
~~~~~

Add the following gradle file in the project root (please install [Gradle](http://www.gradle.org/) first):

~~~~~ groovy
    apply plugin: 'java'
    
    version = '1.0'

    repositories {
        mavenCentral()
    }

    dependencies {
        compile 'org.jodd:jodd-joy:3.5.0'
        runtime 'mysql:mysql-connector-java:5.1.26'
        runtime 'ch.qos.logback:logback-core:1.0.13'
        runtime 'ch.qos.logback:logback-classic:1.0.13'
    }
~~~~~

Execute the following command in project root:

~~~~~
    gradle wrapper
~~~~~

to initialize gradle project. Use your IDE (e.g. IntelliJ IDEA) to open/import the empty Gradle project.

### Database

Create database `jodd-example` in MySql. Create following two tables:

~~~~~ sql
    CREATE TABLE jd_message (
      message_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
      text VARCHAR(1000) NOT NULL,
      PRIMARY KEY (message_id)
    );
    CREATE TABLE jd_response (
      response_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
      text VARCHAR(1000) NOT NULL,
      message_id INT UNSIGNED NOT NULL,
      PRIMARY KEY (response_id),
      FOREIGN KEY (message_id) REFERENCES jd_message(message_id)
    );
~~~~~

Add some dummy data.

### Tomcat

Download and unzip Tomcat. You may delete default web apps. Setup
your IDE to be aware of Tomcat installation.

We are now ready to get our hands dirty!

## Building core

The very first thing is to build the simplest web app core
possible that works and can be started.

### AppCore and WebApplication

We need to define two classes first:

* `AppCore` - initializes and runs our application, and
* `AppWebApplication` - binds `AppCore` to web layer.

Here is the source of these two classes:

~~~~~ java
    public class AppCore extends DefaultAppCore {
    }
~~~~~

~~~~~ java
    public class AppWebAplication extends DefaultWebApplication {
        @Override
        protected DefaultAppCore createAppCore() {
            return new AppCore();
        }
    }
~~~~~

Can't be simpler! Our `AppWebAplication` has one task (for now) - to
create a new application core, that will run the whole application.

### WEB-INF/web.xml

We need to load *Jodd* in the `web.xml`. One way of doing this is:

~~~~~ xml
    <web-app ...>

        <!-- context -->
        <listener>
            <listener-class>jodd.madvoc.MadvocContextListener</listener-class>
        </listener>

        <context-param>
            <param-name>madvoc.webapp</param-name>
            <param-value>jodd.example.AppWebAplication</param-value>
        </context-param>
        <context-param>
            <param-name>madvoc.params</param-name>
            <param-value>/madvoc.props</param-value>
        </context-param>

        <!--listeners-->
        <listener>
            <listener-class>jodd.servlet.RequestContextListener</listener-class>
        </listener>
        <listener>
            <listener-class>jodd.servlet.SessionMonitor</listener-class>
        </listener>

        <!-- madvoc -->
        <filter>
            <filter-name>madvoc</filter-name>
            <filter-class>jodd.madvoc.MadvocServletFilter</filter-class>
        </filter>
        <filter-mapping>
            <filter-name>madvoc</filter-name>
            <url-pattern>/*</url-pattern>
            <dispatcher>REQUEST</dispatcher>
        </filter-mapping>

        <jsp-config>
            <jsp-property-group>
                <url-pattern>*.jsp</url-pattern>
                <page-encoding>UTF-8</page-encoding>
            </jsp-property-group>
        </jsp-config>    
    </web-app>
~~~~~

We have added more stuff in `web.xml` than we gonna actually use in
this example, like listeners (they are required for request and session
scoped beans). The important part here is the registration
of `MadvocContextListener` and `AppWebAplication`.

### app.props

Finally, add file `add.props` to the resources root, containing
the database connection data :

~~~~~
    # database
    jdbc.driverClassName=com.mysql.jdbc.Driver
    jdbc.url=jdbc:mysql://localhost:3306/jodd-example
    jdbc.username=root
    jdbc.password=root!

    # db pool
    dbpool.driver=${jdbc.driverClassName}
    dbpool.url=${jdbc.url}
    dbpool.user=${jdbc.username}
    dbpool.password=${jdbc.password}
    dbpool.maxConnections=50
    dbpool.minConnections=5
    dbpool.waitIfBusy=true
~~~~~

### Run!

That is all - you have just built the simplest *Jodd* application using *Joy*. Yes, you can start Tomcat if you want, to check that everything works. There is nothing to see at this moment, so just pay attention to the
Tomcats log. Now we are ready to go further.


## List last messages

Let's now print last 10 messages on the index page.

### Model

We need to define two domain classes: `Message` and `Response`.
These two will be mapped to database tables.

~~~~~ java
    @DbTable
    public class Message extends IdEntity {

        @DbId
        private long messageId;

        @DbColumn
        private String text;

        // ...getters and setters...
    }
~~~~~

~~~~~ java
    @DbTable
    public class Response extends IdEntity {

        @DbId
        private long responseId;

        @DbColumn
        private String text;

        @DbColumn
        private long messageId;

        // ...getters and setters...
    }
~~~~~

Note that `IdEntity` (and not just `Entity`) uses reflection for retrieving
value of ID field in `hashCode()` and `equals()` methods, in case
that ever becomes a problem. It's a reasonable trade-off for
convenient code.

An addition is also required in application properties: `app.props`:

~~~~~
# db manager
db.debug=true

# db orm manager
dboom.schemaName=PUBLIC
dboom.tableNames.prefix=jd_
dboom.tableNames.uppercase=false
dboom.columnNames.uppercase=false
~~~~~

Here we had to describe database-mapping naming conventions:
all tables have the prefix and both table and column names
are in lowercase. Note that sometimes this depends on how 
JDBC driver work!

### Service

Finally, the time has come to read database and return results. Let's
make an service class:

~~~~~ java
    @PetiteBean
    public class AppService {
        @Transaction(propagation = PROPAGATION_SUPPORTS, readOnly = true)
        public List<Message> findLastMessages(int count) {
            DbSqlBuilder dbsql =
                sql("select $C{m.*} from $T{Message m} " + 
                "order by $m.messageId desc limit :count");
            DbOomQuery dbquery = query(dbsql);
            dbquery.setInteger("count", count);
            return dbquery.list(Message.class);
        }
    }
~~~~~

That is all! Our service is simple POJO class, annotated with `@PetiteBean`
annotation. Nothing else is needed, no XML files, registration etc.
Next, for SQLs queries we used **TSQL** - Template SQL - extension that
allows us to use special macros to reference our Java entities.
This simplifies writing of the native SQL queries. Sure, you may use
plain SQL query instead, no problem!

Noticed the `@Transaction` annotation? Yeah, that is all what is required
to supply your database code with transactional database session. Here is one
tip: you may even define your own annotations to shorten and simplify annotations! For example, you may define e.g. `@ReadOnlyTransaction` or
`@WriteTransaction` and use them instead.

Awesome, right?! The last thing is web part.

### View

We need to add a simple web action that will call the service:

~~~~~ java
    @MadvocAction
    public class IndexAction {

        @PetiteInject
        AppService appService;

        @Out
        List<Message> messages;

        @Action
        public void view() {
            messages = appService.findLastMessages(10);
        }
    }
~~~~~

Again: just a class is added, no other configuration required.
And here is the resulting `index.jsp` page:

~~~~~ html
    <%@ taglib prefix="j" uri="/jodd" %>
    <html>
    <body>
    <h1>Messages</h1>

    <ul>
    <j:iter items="${messages}" var="msg">
        <li>${msg.messageId} ${msg.text}
    </j:iter>
    </ul>
    </body>
    </html>
~~~~~

### Run

Start Tomcat and go to `http://localhost:8080/index.html`. If you have
some data in the database, you will see last 10 messages!

Sweet!

## Messages and responses

Let's add more stuff: list all messages AND their responses as well!

### Model

Add list of `Response` objects in the `Message` class:

~~~~~ java
    @DbTable
    public class Message extends IdEntity {

        ...

        private List<Response> responses;

        public List<Response> getResponses() {
            return responses;
        }

        public void setResponses(List<Response> responses) {
            this.responses = responses;
        }
    }
~~~~~

Nothing special, it's a simple property.

### Service

Service is the place of major change. We will use left join
to gather all messages and their (optional) responses. We will also
use _hints_ in TSQL, to define that responses have to be injected into
the messages. This is going to be done in so called 'entityAware' mode
where many things are done automatically. Here is the code:

~~~~~ java
    @Transaction(propagation = PROPAGATION_SUPPORTS, readOnly = true)
    public List<Message> findLastMessagesWithResponses(int count) {
        DbSqlBuilder dbsql = sql(
                "select $C{m.*}, $C{m.responses:r.*} from $T{Message m} " +
                "left join $T{Response r} using ($.messageId) " +
                "order by $m.messageId desc limit :count");

        DbOomQuery dbquery = query(dbsql);
        dbquery.entityAwareMode(true);
        dbquery.setInteger("count", count);
        return dbquery.list(Message.class, Response.class);
    }
~~~~~

Lets swallow this one:) The only change is in the TSQL. Here is what we said
in English: "Select all columns from Messages (m) and all from Responses (r),
but inject responses into `m.responses` property".

When `entityAware` mode is enabled two effects will happen.
First, all entities during the life of a query
will be cached, so no two instances of the same entity will exist. Second,
result set rows will be compacted if needed. For example, if one message has
two responses, that would give two rows in result set. By compacting this
we will get one message with two responses in the list.

Don't be afraid - this is the most complex syntax you can use in TSQL.
Also, you don't have to use the `entityAware` mode, but then you would
need to populate inner list of `Message` manually - as you would do
if you use the plain JDBC.

### View

View change is simple. Call new method from the action and modify the JSP:

~~~~~ jsp
    <ul>
    <j:iter items="${messages}" var="msg">
        <li>${msg.messageId} ${msg.text}
            <ul>
                <j:iter items="${msg.responses}" var="resp">
                    <li>${resp.responseId} ${resp.text}</li>
                </j:iter>
            </ul>
        </li>
    </j:iter>
    </ul>
~~~~~

We just have added a inner loop over responses.

### Run

Yes, you may run the example :) It works! Enjoy!


## Add message

You want more? Let's allow users to add new message.

### Service

Lets first code a service method in existing service class:

~~~~~ java
    @Transaction(propagation = PROPAGATION_SUPPORTS, readOnly = false)
    public void addMessage(Message message) {
        DbEntitySql.insert(message).query().executeUpdateAndClose();
    }
~~~~~

Wait, that is all!? Yes, that is all, we didn't write any SQL code here.
`DbEntitySql` is a helper class that generates all that simple and common
queries for inserting, updating, finding.

### View

Now lets focus on view part. We will need a new page with a form.
But also, we will need a submit action to be handled, too. Thats
in total 2 new actions that we need to add. Create class `MessageAction`:

~~~~~ java
    @MadvocAction
    public class MessageAction {

        @PetiteInject
        AppService appService;

        @In
        Message message;

        @Action(extension = "do")
        public String add() {
            appService.addMessage(message);
            return "redirect:/<index>";
        }

        @Action
        public void view() {
        }
    }
~~~~~

We have two mappings here: `/message.html` to `view()` method and
`/message.add.do` to `add()` method. First method just shows the form
on `message.jsp` page:

~~~~~ jsp
    <html>
    <body>
    <h1>Add Message</h1>

    <form action="/message.add.do" method="POST">
        <textarea name="message.text" rows="5" cols="50"></textarea>
        <button type="submit">Submit</button>
    </form>

    </body>
    </html>
~~~~~

The second action method is more interesting. First, we have different
extension. Note that we can define a custom annotations for
actions, too! Second, we are doing the redirection after new message is added.
For redirection result, we need to specify the path where we gonna
redirect. But we don't want to hardcode page names, so we are using the
_aliases_. Each action can be named and that name can be used to resolve
the real path action is mapped to. There is even an option so all *Madvoc*
actions gets aliases, or we can do this manually:

~~~~~ java
    @MadvocAction
    public class IndexAction {
        @Action(alias = "index")
        public void view() {
            ....
        }
    }
~~~~~

Now the index action is named with a name that is used for redirection.

### Run

It's running time again! Go to `http://localhost:8080/message.html` and
add new messages. It's fun! :)


## That's all folks!

This tutorial is about to end. We learned how easy we can build
web applications with *Jodd*. But this is just the essentials,
*Jodd* is packed with many more features... like *Decora* (page template
engine), *VTor* (validation micro framework) or *HtmlStapler* (for joining
web resources)...

Enjoy!