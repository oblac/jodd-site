---
javadoc: 'mail'
---

# Email

Sending emails in Java should be easier. *Jodd* provides some nice classes for sending and receiving emails in an easier, practical way.

## E-mail definition

Email is defined as simple POJO bean of type `Email`. Each part of email message can be set separately. Moreover, `Email` supports fluent interface, so even definition of an e-mail message would look natural.

`Email` supports plain text, HTML messages and any combination of both. When only text or HTML message is set, simple email will be sent. When both text and HTML message is set, or when attachments are added, multipart e-mail will be sent. Actually, `Email` supports any number of separate messages to be sent as an email. Here are some examples using fluent interface.

Plain-text email:

~~~~~ java
    Email email = Email.create()
        .from("john@jodd.org")
        .to("anna@jodd.org")
        .subject("Hello!")
        .textMessage("A plain text message...");
~~~~~

HTML email:

~~~~~ java
    Email email = Email.create()
        .from("john@jodd.org")
        .to("anna@jodd.org")
        .subject("Hello HTML!")
        .htmlMessage("<b>HTML</b> message...");
~~~~~

Text and HTML email, high priority:

~~~~~ java
    Email email = Email.create()
        .from("john@jodd.org")
        .to("anna@jodd.org")
        .subject("Hello!")
        .textMessage("text message...")
        .htmlMessage("<b>HTML</b> message...")
        .priority(PRIORITY_HIGHEST);
~~~~~

### Email Addresses

All email addresses (from, to, cc...) may be specified in following ways:

+ only by email address, e.g.: `some.one@jodd.com`
+ by personal (display) name and email address in one string, e.g.: `John <some.one@jodd.com>`
+ by separate personal (display) name and email address
+ by providing `EmailAddress`, class that parses and validates emails per specification
+ by providing `InternetAddress` or just `Address` instance.


Consider using personal names as it is less likely your message is going to be marked as spam ;)

Multiple email addresses are specified using arrays or by calling methods `to()` or `cc()` multiple times:

~~~~~ java
    Email email = Email.create()
        .from("john@jodd.org")
        .to("adr1@jodd.org", "adr2@jodd.org")
        .cc("xxx@bar.com")
        .cc(zzz@bar.com")
        .subject("Hello HTML!")
        .htmlMessage("<b>HTML</b> message");
~~~~~

## Attachments

There are several attachment types that can be added:

+ from memory byte array,
+ from input stream,
+ from a file,
+ from generic `DataSource`.

File attachments depend on `javax.mail` content type resolution (that might not work for you). You can always attach files as byte or input stream attachment.
{: .attn}

Attachments are created using the `EmailAttachment` class:

~~~~~ java
    .attachment(EmailAttachment.with()
        .name("some name")
        .content(bytesOfImage)
~~~~~

The `content()` method accepts different attachment types.

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

~~~~~ java
    Email email = Email.create()
        .from("inf0@jodd.org")
        .to("ig0r@gmail.com")
        .subject("test6")
        .textMessage("Hello!")
        .htmlMessage(
            "<html><META http-equiv=Content-Type content=\"text/html; " +
            "charset=utf-8\"><body><h1>Hey!</h1><img src='cid:c.png'>" +
            "<h2>Hay!</h2></body></html>")
        .embeddedAttachment(EmailAttachment.with()
            .content(new File("/c.png")))
        .attachment(EmailAttachment.with()
            .content("/b.jpg"));
~~~~~

## Sending emails

Emails are sent using `SendMailSession`. Mail session encapsulates
process of preparing emails, opening and closing transport connection
and sending emails.

Mail session is created by the `MailServer`.

~~~~~ java
    SmtpServer smtpServer = MailServer.create()
            .host("http://mail.com")
            .port(21)
            .buildSmtpMailServer();
    ...
    SendMailSession session = smtpServer.createSession();
    session.open();
    session.sendMail(email1);
    session.sendMail(email2);
    session.close();
~~~~~

Since opening session and sending emails may produce `EmailException`, it is necessary to wrap methods in `try`-`catch` block and closing the session in the `finally` block.

## Sending using SSL

Preferred way for sending e-mails is using SSL protocol. *Jodd* supports secure e-mail sending. Just set the `ssl()` flag while creating the server.

Here is an example of sending e-mail via [Gmail](http://gmail.com) (port 465 is set by default):

~~~~~ java
    SmtpServer smtpServer = MailServer.create()
            .ssl(true)
            .host("smtp.gmail.com")
            .auth("user@gmail.com", "password")
            .buildSmtpMailServer();
    ...
    SendMailSession session = smtpServer.createSession();
    session.open();
    session.sendMail(email);
    session.close();
~~~~~

Everything is the same, just different session provider is used.

## Receiving emails

Receiving emails is similar to sending: there are classes that encapsulates POP3 and IMAP connections, i.e. servers. Both creates the same receiving session - `ReceiveMailSession` - that fetches emails and return them as an array of `ReceivedEmails`. This way you work with both POP3 and IMAP servers in the very same way.

Even the instance of the same class `ReceiveMailSession` is created by both POP3 and IMAP servers implementations, **not all** methods work in the same way! This difference depends on server type. Commonly, POP3 has less features (e.g. not being able to fetch all folder names for GMail account), while IMAP server is richer (e.g. it supports server-side search).
{: .attn}

During receiving, all emails are fetched and returned as an array of `ReceivedEmail` objects. This is a POJO object, so its very easy to work with. It provides many helpful methods, too. Each `ReceivedEmail` also contains a list of all messages, attachments and attached messages (EMLs).

There are several methods for fetching emails:

+ `receiveEmail()` - returns all emails, but don't change the 'seen' flag.
+ `receiveEmailAndMarkSeen()` - returns all emails and marked all messages as 'seen'.
+ `receiveEmailAndDelete()` - returns all emails and mark them as 'seen' and 'deleted'.

The first method does a little trick: since `javax.mail` always set a 'seen' flag when new message is downloaded, we do set it back on 'unseen' (if it was like that before fetching). This way `receiveEmail()` should not change the state of your inbox.

Most likely you will use `receiveEmailAndMarkSeen()` or `receiveEmailAndDelete()`.
{: .attn}


### POP3

For POP3 connection, use `Pop3Server`:

~~~~~ java
    Pop3Server popServer = MailServer.create().
            host("pop3.jodd.org",
            auth("username", "password")
            .buildPop3MailServer();

    ReceiveMailSession session = popServer.createSession();
    session.open();
    System.out.println(session.getMessageCount());
    ReceivedEmail[] emails = session.receiveEmailAndMarkSeen();
    if (emails != null) {
        for (ReceivedEmail email : emails) {
            System.out.println("\n\n===[" + email.getMessageNumber() + "]===");

            // common info
            System.out.println("FROM:" + email.from());
            System.out.println("TO:" + email.to()[0]);
            System.out.println("SUBJECT:" + email.subject());
            System.out.println("PRIORITY:" + email.priority());
            System.out.println("SENT DATE:" + email.sentDate());
            System.out.println("RECEIVED DATE: " + email.receiveDate());

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

Again, very simply: use the very same `ssl()` flag. Here is how it can be used to fetch email from Google:

~~~~~ java
    Pop3Server popServer = MailServer.create()
        .host("pop.gmail.com")
        .ssl(true)
        .auth("username", "password")
        .buildPop3MailServer();

    ReceiveMailSession session = popServer.createSession();
    session.open();
    ...
    session.close();
~~~~~

### IMAP

Above example can be converted to IMAP usage very easily:

~~~~~ java
    ImapServer imapServer = MailServer.create()
        .host("pop.gmail.com")
        .ssl(true)
        .auth("username", "password")
        .buildImapMailServer();

    ReceiveMailSession session = imapServer.createSession();
    session.open();
    ...
    session.close();
~~~~~

Can't be easier:)

As said above, when working with IMAP server, many methods of `ReceiveMailSession` works better or... simply, just works. For example, you should be able to use following methods:

+ `getUnreadMessageCount()` - to get number of un-seen messages.
+ `getAllFolders()` - to receive all folders names
+ server-side filtering - read the next chapter

## Receiving Envelopes

There is an option to receive only email envelopes: the header information, like `from` and `subject` but not the content of the messages. Receiving only envelopes makes things faster and it make more sense in situations when not all messages have to be received.

Each email has it's own ID that is fetched as well. Later on, you can use this ID to filter out just the messages with specific ID.

## Receive builder

`ReceiveMailSession` provides an builder for fine-tuning the received emails:

~~~~~ java

    session
        .receive()
        .markSeen()
        .fromFolder("work")
        .filter(...)
        .get();

~~~~~


## Filtering emails

IMAP server also knows about server-side filtering of emails. There are two ways how to construct email filter, and both can be used in the same time.

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

Static method `filter()` is a factory of `EmailFilter` instances. Above filter defines the following query expressions:

~~~~~
    (from:"from" AND to:"to") OR not(subject:"subject") OR from:"from"
~~~~~

With this approach you can define boolean queries of any complexity. But there is a more fluent way to write the same query:

~~~~~ java
    filter()
        .from("from")
        .to("to")
        .or()
        .not()
        .subject("subject")
        .from("from2");
~~~~~

Here we use non-argument methods to define _current_ boolean operator: `and()` and `or()`. All terms defined _after_ the boolean marker method uses that boolean operator. Method `not()` works only for the very _next_ term definition. This way you probably can not defined some complex queries, but it should be just fine for the real life usages.

Here is how we can use simple filter when fetching emails:

~~~~~ java
    ReceivedEmail[] emails = session.receiveEmail(filter()
            .flag(Flags.Flag.SEEN, false)
            .subject("Hello")
    );
~~~~~

This would return all unread messages with subject equals to "Hello".

Note that for IMAP server, the search is executed by the IMAP server. This significantly speeds up the fetching process as not all messages are downloaded. Note that searching capabilities of IMAP servers may vary.

You can use the same filters on POP3 server, but keep in mind that the search is performed on the client-side, so still all messages have to be downloaded before the search is thrown.
