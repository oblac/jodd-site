# Email

Sending emails in Java should be easier. *Jodd* provides some nice classes
for sending emails in an easier, practical way.

## E-mail definition

E-mail is defined as simple POJO bean of type `Email`. Each part of
e-mail message can be set separately. Moreover, `Email` supports fluent
interface, so even definition of an e-mail message would look natural.

`Email` supports plain text, HTML messages and any combination of both.
When only text or HTML message is set, simple e-mail will be sent. When
both text and HTML message is set, or when attachments are added,
multipart e-mail will be sent. Actually, `Email` supports any number of
separate messages to be sent as an email. Here are some examples using
fluent interface.

Plain-text email:

~~~~~ java
    Email email = Email.create()
        .from("...@jodd.org")
        .to("...@jodd.org")
        .subject("Hello!")
        .addText("A plain text message...");
~~~~~

HTML email:

~~~~~ java
    Email email = Email.create()
        .from("...@jodd.org")
        .to("...@jodd.org")
        .subject("Hello HTML!")
        .addHtml("<b>HTML</b> message...");
~~~~~

Text and HTML email, high priority:

~~~~~ java
    Email email = Email.create()
        .from("...@jodd.org")
        .to("...@jodd.org")
        .subject("Hello!")
        .addText("text message...")
        .addHtml("<b>HTML</b> message...")
        .priority(PRIORITY_HIGHEST);
~~~~~

### Email Addresses

All email addresses (from, to, cc...) may be specified in following ways:

+ only by email address, eg: `some.one@jodd.com`
+ by personal (display) name and email address in one string, eg: `John <some.one@jodd.com>`
+ by separate personal (display) name and email address
+ by providing `EmailAddress`, class that parses and validates emails per specification
+ by providing `InternetAddress` or just `Address` instance.

Consider using personal names as it is less likely your message is
going to be marked as spam ;)

Multiple email addresses are specified by repeated call to relevant method:

~~~~~ java
    Email email = Email.create()
        .from("...@jodd.org")
        .to("adr1@jodd.org")
        .to("adr2@jodd.org")
        .cc("xxx@bar.com")
        .cc("zzz@bar.com")
        .subject("Hello HTML!")
        .addHtml("<b>HTML</b> message");
~~~~~

Alternatively you may pass an array of strings, `EmailAddress` or
`InternetAddress`. In this case, the addresses will not be appended,
but replaced!

## Attachments

There are several attachment types that can be added:

* bytes attachment (`ByteArrayAttachment`), when byte content is added
  as attachment,
* input stream attachment (`InputStreamAttachment`), when input stream
  will be read on sending,
* file attachment (`FileAttachment`), for files,
* and generic `DataSource` based attachment.

One note for file attachments - they depend on `javax.mail` content type
resolution (that might not work for you). You can always attach files as
byte or input stream attachment.
{: .attn}

Adding attachments is also easy - just create an attachment class and
`attach()` it.

However, there is an alternative way of building attachment classes,
more convenient one, using `EmailAttachmentBuilder`. It is sufficient
for most cases and easier to use (see examples in next section).

### Embedded (inline) attachments

Special case of attachments are *inline* attachments. These are usually
related content for HTML message, like images, that should appear inside
the message, and not separate as real attachment.

Embedding is also supported. All attachments created with the
`ContentID` set will be considered as inline attachments. However, they
also need to be embedded to certain message, to form a so-called
*related* part of an email. Email clients usually requires to have all
inline attachments related to some message.

## Example

Here is an example of creating the same message, but using two ways of
building the `Email`.

### Email using common API

This is default way of building `Email`. It is very verbose, but you
have the most control. So here it is.

~~~~~ java
    Email email = new Email();

    email.setFrom("infoxxx@jodd.org");
    email.setTo("igorxxxx@gmail.com");
    email.setSubject("test7");

    EmailMessage textMessage = new EmailMessage("Hello!", MimeTypes.MIME_TEXT_PLAIN);
    email.addMessage(textMessage);

    EmailMessage htmlMessage = new EmailMessage(
        "<html><META http-equiv=Content-Type content=\"text/html; charset=utf-8\">" +
        "<body><h1>Hey!</h1><img src='cid:c.png'><h2>Hay!</h2></body></html>",
    MimeTypes.MIME_TEXT_HTML);
    email.addMessage(htmlMessage);

    EmailAttachment embeddedAttachment =
        new ByteArrayAttachment(
            FileUtil.readBytes("/c.png"), "image/png", "c.png", "c.png");
    embeddedAttachment.setEmbeddedMessage(htmlMessage);
    email.attach(embeddedAttachment);

    EmailAttachment attachment = new FileAttachment(
        new File("/b.jpg"), "b.jpg", "image/jpeg");
    email.attach(attachment);
~~~~~

Let's analyze. We create empty `Email` and then set from, to and
subject. Then, in lines #7 and #8 we create plain text message. Few rows
later (#10 - #14) we create HTML message. This message uses one inline
attachment referred as `c.png`. So we create inline
`ByteArrayAttachment` - it's inline because we have specified the
ContentID (last argument). This inline attachment has to be embedded to
a message (line #18). Finally, we create a regular attachment and attach
it to the email.

### Email using fluent API

Fluent API is less verbose and, therefore, more convenient. Here is the
same example from above:

~~~~~ java
    Email email = Email.create()
        .from("infoxxxx@jodd.org")
        .to("igorxxxxxx@gmail.com")
        .subject("test6")
        .addText("Hello!")
        .addHtml(
            "<html><META http-equiv=Content-Type content=\"text/html; charset=utf-8\">"+
            "<body><h1>Hey!</h1><img src='cid:c.png'><h2>Hay!</h2></body></html>")
        .embed(attachment().bytes(new File("/c.png")))
        .attach(attachment().file("/b.jpg"));
~~~~~

As you see, it's really less code:) Biggest difference here is that
instead of creating email attachments using constructors, we have been
using `EmailAttachment.attachment()` helper - a smart factory for email
attachment classes.

Important note: `embed()` method embeds attachment to the **last**
message! Hence the order of methods is important.
{: .attn}

Both ways are equally valid, just be sure to understand all consequences
of using it.

## Sending e-mails

Emails are sent using `SendMailSession`. Mail session encapsulates
process of preparing emails, opening and closing transport connection
and sending emails. Mail sessions should be created by some
`SendMailSessionProvider`. One such provider already exist:
`SmtpServer`. It encapsulates SMTP server that might use simple
authentication.

With send mail session it is possible to send several emails at once,
using just one connection. This is significantly faster then to opening
session for each email.

Here is an example of sending previously defined emails:

~~~~~ java
    SmtpServer smtpServer = SmtpServer.create("mail.jodd.org")
                .authenticateWith("user", "password");
    ...
    SendMailSession session = smtpServer.createSession();
    session.open();
    session.sendMail(email1);
    session.sendMail(email2);
    session.close();
~~~~~

Since opening session and sending emails may produce `EmailException`,
it is necessary to wrap methods in `try`-`catch` block and closing the
session in the `finally` block.

`SmtpServer` uses fluent interface so you can easily specify different
configuration. For example:

~~~~~ java
        SmtpServer smtpServer = SmtpServer
                .create("some.host.com", 587)
                .authenticateWith("test", "password")
                .timeout(10)
                .properties(overridenProperties);
~~~~~

Here we specified the timeout value and provide additional mail properties
for the SMTP server.

## Sending using SSL

Preferred way for sending e-mails is using SSL protocol. *Jodd* supports
secure e-mail sending with `SmtpSslServer`, a subclass of `SmtpServer`.
Here is an example of sending e-mail via [Gmail](http://gmail.com) (port
465 is set by default):

~~~~~ java
    SmtpServer smtpServer = SmtpSslServer
            .create("smtp.gmail.com")
            .authenticateWith("user@gmail.com", "password");
    ...
    SendMailSession session = smtpServer.createSession();
    session.open();
    session.sendMail(email);
    session.close();
~~~~~

Everything is the same, just different session provider is used.

## Receiving emails

Receiving emails is similar to sending: there are classes that encapsulates
POP3 and IMAP connections, i.e. servers. Both creates the same receiving
session - `ReceiveMailSession` - that fetches emails and return them as
an array of `ReceivedEmails`. This way you work with both POP3 and IMAP
servers in the very same way.

Even the instance of the same class `ReceiveMailSession` is created by both
POP3 and IMAP servers implementations, **not all** methods work in the same
way! This difference depends on server type. Commonly, POP3 has less features
(e.g. not being able to fetch all folder names for GMail account), while IMAP
server is reacher (e.g. it supports server-side search).
{: .attn}

During receiving, all emails are fetched and returned as an array of
`ReceivedEmail` objects. This is a POJO object, so its very easy to work with.
It provides many helpful methods, too. Each `ReceivedEmail` also contains a
list of all messages, attachments and attached messages (EMLs).

There are several methods for fetching emails:

+ `receiveEmail()` - returns all emails, but don't change the 'seen' flag.
+ `receiveEmailAndMarkSeen()` - returns all emails and marked all messages as 'seen'.
+ `receiveEmailAndDelete()` - returns all emails and mark them as 'seen' and 'deleted'.

The first method does a little trick: since `javax.mail` always set a 'seen'
flag when new message is downloaded, we do set it back on 'unseen' (if it was
like that before fetching). This way `receiveEmail()` should not change the
state of your inbox.

Most probably you will need `receiveEmailAndMarkSeen()` or `receiveEmailAndDelete()`.
{: .attn}

### POP3

For POP3 connection, use `Pop3Server`:

~~~~~ java
    Pop3Server popServer = new Pop3Server("pop3.jodd.org",
            new SimpleAuthenticator("username", "password"));
    ReceiveMailSession session = popServer.createSession();
    session.open();
    System.out.println(session.getMessageCount());
    ReceivedEmail[] emails = session.receiveEmailAndMarkSeen();
    if (emails != null) {
        for (ReceivedEmail email : emails) {
            System.out.println("\n\n===[" + email.getMessageNumber() + "]===");

            // common info
            Printf.out("%0x", email.getFlags());
            System.out.println("FROM:" + email.getFrom());
            System.out.println("TO:" + email.getTo()[0]);
            System.out.println("SUBJECT:" + email.getSubject());
            System.out.println("PRIORITY:" + email.getPriority());
            System.out.println("SENT DATE:" + email.getSentDate());
            System.out.println("RECEIVED DATE: " + email.getReceiveDate());

            // process messages
            List messages = email.getAllMessages();
            for (EmailMessage msg : messages) {
                System.out.println("------");
                System.out.println(msg.getEncoding());
                System.out.println(msg.getMimeType());
                System.out.println(msg.getContent());
            }

            // process attachments
            List<EmailAttachment> attachments = email.getAttachments();
            if (attachments != null) {
                System.out.println("+++++");
                for (EmailAttachment attachment : attachments) {
                    System.out.println("name: " + attachment.getName());
                    System.out.println("cid: " + attachment.getContentId());
                    System.out.println("size: " + attachment.getSize());
                    attachment.writeToFile(
                        new File("d:\\", attachment.getName()));
                }
            }
        }
    }
    session.close();
~~~~~

### Receiving emails using SSL

Again, very simply: use `Pop3SslServer` implementation. Here is how it can be used to fetch email from Google:

~~~~~ java
    Pop3Server popServer = new Pop3SslServer("pop.gmail.com", "username", "password");
    ReceiveMailSession session = popServer.createSession();
    session.open();
    ...
    session.close();
~~~~~

### IMAP

Above example can be converted to IMAP usage very easily:

~~~~~ java
    ImapServer imapServer =
        new ImapSslServer("imap.gmail.com", "username", "password");
    ReceiveMailSession session = imapServer.createSession();
    session.open();
    ...
    session.close();
~~~~~

Can't be easier:)

As said above, when working with IMAP server, many methods of `ReceiveMailSession` works better
or... simply, just works. For example, you should be able to use following methods:

+ `getUnreadMessageCount()` - to get number of un-seen messages.
+ `getAllFolders()` - to receive all folders names
+ server-side filtering - read next chapter


## Filtering emails

IMAP server also knows about server-side filtering of emails. There are two
ways how to construct email filter, and both can be used in the same time.

The first approach is by grouping terms:

~~~~~ java
    filter()
        .or(
            filter().and(
                filter().from("from"),
                filter().to("to")
            ),
            filter().not(filter().subject("subject")),
            filter().from("from2")
        );
~~~~~

Static method `filter()` is a factory of `EmailFilter` instances. Above filter
defines the following query expressions:

~~~~~
    (from:"from" AND to:"to") OR not(subject:"subject") OR from:"from"
~~~~~

With this approach you can define boolean queries of any complexity. But there
is a more fluent way to write the same query:

~~~~~ java
    filter()
        .from("from")
        .to("to")
        .or()
        .not()
        .subject("subject")
        .from("from2");
~~~~~

Here we use non-argument methods to define _current_ boolean operator: `and()` and `or()`.
All terms defined _after_ the boolean marker method uses that boolean operator. Method
`not()` works only for the very _next_ term definition. This way you probably can not
defined some complex queries, but it should be just fine for the real life usages.

Here is how we can use simple filter when fetching emails:

~~~~~ java
    ReceivedEmail[] emails = session.receiveEmail(filter()
            .flag(Flags.Flag.SEEN, false)
            .subject("Hello")
    );
~~~~~

This would return all unread messages with subject equals to "Hello".

Note that for IMAP server, the search is executed by the IMAP server.
This significantly speeds up the fetching process as not all messages
are downloaded. Note that searching capabilities of IMAP servers may vary.

You can use the same filters on POP3 server, but keep in mind that
the search is performed on the client-side, so still all messages
have to be downloaded before the search is thrown.


## Everything else...

### Parsing EML files

What if you have your emails stored in EML files. Not a problem, just use
`EMLParser.create().parse()`. It accepts both file or files content as an input and
returns `ReceivedEmail` of parsed EML message.

### Gmail and new message count

Gmail does not support the Recent flags on messages. Since the
`getNewMessageCount()` method counts messages with the RECENT flags, *Jodd*
will not (yet) find any such messages on Gmail servers (hence always returning
value 0).

### Email parsing and validation

*Jodd* offer one great class for parsing and validating emails: `EmailAddress`.
It works per RFC2822 standard. This class can be trusted to only
provide authenticated results. Since the standard is quite complex,
it is not a perfect yet, but it works much better then other solutions.
