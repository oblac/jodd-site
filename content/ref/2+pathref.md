# Pathref

Similar to `Methref`, the `Pathref` returns the _bean path_ of the property.
The usage is very similar:

~~~~~ java
	Pathref<User> p = Pathref.on(User.class);


	p.path(p.to()
		.getFriends()
		.get(2)
		.getAddress()
		.getStreet());		// friends[2].address.street
~~~~~

Bean path can be used later in reading the property using e.g. `BeanUtil`.