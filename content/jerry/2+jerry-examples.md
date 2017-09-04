# Jerry Examples

Here are some examples of *Jerry* usages on some live pages.

Following examples depend on content of live web pages. At some point in
time pages may change in such way that the examples stop working.
{: .attn}

## New music releases from allmusic.com

Site [allmusic.com][2] shows new music releases in the
right column. Here is a simple code that downloads the page, parse it
and displays all releases in console:

~~~~~ java
    public class AllMusicNewReleases {

        public static void main(String[] args) throws IOException {

            // download the page super-efficiently
            File file = new File(SystemUtil.getTempDir(), "allmusic.html");
            NetUtil.downloadFile("http://allmusic.com", file);

            // create Jerry, i.e. document context
            Jerry doc = Jerry.jerry(FileUtil.readString(file));

            // parse
            doc.$("div#new_releases div.list_item").each(new JerryFunction() {
                public boolean onNode(Jerry $this, int index) {
                    System.out.println("-----");
                    System.out.println($this.$("div.album_title").text());
                    System.out.println($this.$("div.album_artist").text().trim());
                    return true;
                }
            });
        }
    }
~~~~~

Nice :)

## Change Google page

Let's remove toolbar from Google page and remove Google logo image with
simple HTML text.

~~~~~ java
    public class ChangeGooglePage {

        public static void main(String[] args) throws IOException {

            // download the page super-efficiently
            File file = new File(SystemUtil.getTempDir(), "google.html");
            NetUtil.downloadFile("http://google.com", file);

            // create Jerry, i.e. document context
            Jerry doc = Jerry.jerry(FileUtil.readString(file));

            // remove div for toolbar
            doc.$("div#mngb").detach();
            // replace logo with html content
            doc.$("div#lga").html("<b>Google</b>");

            // produce clean html...
            String newHtml = doc.html();
            // ...and save it to file system
            FileUtil.writeString(
                new File(SystemUtil.getTempDir(), "google2.html"),
                newHtml);
        }
    }
~~~~~

Easy!

## Facebook bot

To demonstrate the power of *Jerry*, we created a little Facebook bot
just for fun:) The task was to create a bot that will login to Facebook
account, list friends proposals and send a few "Add friend"
requests. To see how, [read it here.](facebook-bot.html)

Next example is similar, it uses *Jerry* and *Http* to login to facebook.
This time everything is done with *Jodd*, no need for 3rd party libs.
[Take a look.](facebook.html)


## Jerry parses POM XML (too)!

*Jerry* can be used to parse XML files, too! We needed to parse Maven
POM files, in order to display dependencies on our download page. First,
we had to enable the XML mode of *Lagarto* parser:

~~~~~ java
    Jerry.JerryParser jerryParser = new Jerry.JerryParser();
    jerryParser.enableXmlMode();
    Jerry doc = jerryParser.parse(FileUtil.readString(pomFile));
~~~~~

and then we can access the content via CSS selectors, for example:

~~~~~ java
    Jerry dependencies = doc.$("dependencies dependency");

    dependencies.each(new JerryFunction() {
        @Override
        public boolean onNode(Jerry $this, int index) {
            // skip test dependencies
            if ($this.$("scope").text().equals("test")) {
                return true;
            }

            String artifactId = $this.$("artifactId").text();
            String optionalStr = $this.$("optional").text();

            // process

            return true;
        }
    });
~~~~~

Complete code you can find [here][3].

## Jerry on Groovy!

*Jerry* can be used very nicely in Groovy! [Rob Flatcher][4] uses it in Groovy tests like this (snippet):

~~~~~ java
    import static jodd.jerry.Jerry.jerry as $

    def dom = $(output)

    def labels = dom.find('label')
    labels*.attr('for') == ['foo_hours', 'foo_minutes', 'foo_seconds']
    labels*.text() == ['\u00a0hours ', '\u00a0minutes ', '\u00a0seconds ']
    labels.every {
        it.find(':input').attr('id') == it.attr('for')
    }
~~~~~

For more details, check unit tests in [grails-joda-time][5].

[2]: http://allmusic.com
[3]: http://github.com/oblac/tools/blob/master/src/jodd/tools/modlist/PomList.java
[4]: http://freeside.co/
[5]: https://github.com/gpc/grails-joda-time
