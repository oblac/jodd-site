# Sending and Receiving Emails ![email](/gfx/email-tool.png "Email")

Sending emails in Java should be easier. *Jodd* provides several classes
for sending emails in an easier way.

## E-mail definition

E-mail is defined as simple POJO bean of type `Email`. Each part of
e-mail message can be set separately. Moreover, `Email` supports fluent
interface, so even definition of an e-mail message would look natural.

`Email` supports plain text, HTML messages and any combination of both.
When only text or html message is set, simple e-mail will be sent. When
both text and HTML message is set, or when attachments are added,
multipart e-mail will be sent. Actually, `Email` supports any number of
separate messages to be sent as an email. Here are some examples using
fluent interface.

Plain-text email:

~~~~~ java
    Email email = Email.create()
        .from("...@jodd.org").to("...@jodd.org")
        .subject("Hello!")
        .addText("A plain text message...");
~~~~~

HTML email:

~~~~~ java
    Email email = Email.create()
        .from("...@jodd.org").to("...@jodd.org")
        .subject("Hello HTML!")
        .addHtml("<b>HTML</b> message...");
~~~~~

Text and HTML email, high priority:

~~~~~ java
    Email email = Email.create()
        .from("...@jodd.org").to("...@jodd.org")
        .subject("Hello!")
        .addText("text message...")
        .addHtml("<b>HTML</b> message...")
        .priority(PRIORITY_HIGHEST);
~~~~~

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
instead of creating emai attachments using constructors, we have been
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
`SmtpServer`. It encapsulates smtp server that might use simple
authentication.

With send mail session it is possible to send several emails at once,
using just one connection. This is significantly faster then to opening
session for each email.

Here is an example of sending previously defined emails:

~~~~~ java
    SmtpServer smtpServer =
        new SmtpServer("mail.jodd.org", new SimpleAuthenticator("user", "pass"));
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

## Sending using SSL

Preferred way for sending e-mails is using SSL protocol. *Jodd* supports
secure e-mail sending with `SmtpSslServer`, subclass of `SmtpServer`.
Here is an example of sending e-mail via [Gmail](http://gmail.com) (port
465 is set by default):

~~~~~ java
    SmtpServer smtpServer =
        new SmtpSslServer("smtp.gmail.com", "user@gmail.com", "password"));
    ...
    SendMailSession session = smtpServer.createSession();
    session.open();
    session.sendMail(email);
    session.close();
~~~~~

Everything is the same, just different session provider is used.

## Receiving emails

Receiving emails is similar to sending: `Pop3Server` creates
`ReceiveMailSession` that retrieves `ReceivedEmails`.

~~~~~ java
    Pop3Server popServer = new Pop3Server("pop3.jodd.org",
            new SimpleAuthenticator("username", "password"));
    ReceiveMailSession session = popServer.createSession();
    session.open();
    System.out.println(session.getMessageCount());
    ReceivedEmail[] emails = session.receiveEmail(false);
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
            LinkedList messages = email.getAllMessages();
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
                    attachment.writeToFile(new File("d:\\", attachment.getName()));
                }
            }
        }
    }
    session.close();
~~~~~

## Receiving emails using SSL

Again, very simply: use `Pop3SslServer` implementation. Here is how it can be used to fetch email from Google:

~~~~~ java
    Pop3Server popServer = new Pop3SslServer("pop.gmail.com", "username", "password");
    ReceiveMailSession session = popServer.createSession();
    session.open();
    ...
    session.close();
~~~~~

## Gmail and new message count

Gmail does not support the Recent flags on messages. Since the `getNewMessageCount()` method counts messages with the RECENT flags, *Jodd* will not (yet) find any such messages on Gmail servers (hence always returning value 0).
