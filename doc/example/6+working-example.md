# Working example

Let's modify our webapp example. Instead of passing the name, we will
pass the user id, then find it in the database, and print it in the jsp.

## Action

~~~~~ java
    @MadvocAction
    public class IndexAction {

    	@PetiteInject
    	FooService fooService;

    	@In
    	Long id;

    	@Out
    	User user;

    	@Action
    	public void view() {
    		if (id != null) {
    			user = fooService.findUserById(id);
    			System.out.println(user);
    		}
    	}
    }
~~~~~

## JSP

~~~~~ html
    <html>
    <head>
    	<title>Jodd</title>
    	</head>
    <body>
    ...hello ${user.name}...
    </body>
    </html>
~~~~~

## Service

~~~~~ java
    @PetiteBean
    public class FooService {

    	@PetiteInject
    	AppDao appDao;

    	@Transaction(propagation = PROPAGATION_SUPPORTS, readOnly = false)
    	public void storeUser(User user) {
    		appDao.store(user);
    	}

    	@Transaction(propagation = PROPAGATION_SUPPORTS)
    	public User findUserById(long id) {
    		return appDao.findById(User.class, Long.valueOf(id));
    	}
    }
~~~~~

## Final words

This example ends here, but it is just a beginning for your quest
through *Jodd*!
