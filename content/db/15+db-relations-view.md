# DB Relations

*DbOom* does not provide relations mapping out-of-box. Instead, developer
is able to use relations whenever he needs them. And it is not so
complicated as it sounds.

## Example

![db relations](db-relations.png){: .right}
`Question` may have many `Answer`s,
but only one `Country`. Lets see how to model this relation in Java in
order to be convenient and easy to use.

## 1-to-1 relations

Foreign keys to other entities should be mapped in parent entity. Here,
`Question` has `countryId` property mapped to corresponding column in
database, as any other column:

~~~~~ java
    @DbTable
    public class Question extends Entity {

    	@DbColumn
    	Long countryId;

    	...
    }
~~~~~

Having FK id mapped to entity is often convenient: when you need to
update or delete questions `Country`, you just need the id (and not the
`Country` instance).

On the other hand, sometimes it is required (or just handy:) to have
full `Country` object in `Question`. For those situations we usually put
the following set and get methods pair:

~~~~~ java
	Country country;

	public Country getCountry() {
		return country;
	}

	public void setCountry(Country country) {
		countryId = country == null ? null : country.getId();
		this.country = country;
	}
~~~~~

How to populate the country? One solution is to simply execute
`AppDao#findById(Country.class, id)` when `Country` is needed. Other
solution, for 1-1 relationships, is to fetch both `Question` and
`Country` together, using [join hints](sqlgenerator.html) in template
sql:

~~~~~ sql
    select $C{question.*}, $C{question.country.*} from $T{Question question}
    join $T{Country country} on $country.id=$question.countryId
~~~~~

## 1-to-many relations

In our example `Question` may have some `Answers`. There is nothing to
map or configure in `Question` for this relation. `Answer`s has to be
loaded manually when needed. Here is what we usually put for 1-to-many
relations in parent entity (here: `Question`).

~~~~~ java
    public class Question extends Entity {
    	...

    	List answers = new ArrayList();

    	public List getAnswers() {
    		return answers;
    	}

    	public void setAnswers(List answers) {
    		this.answers = answers;
    		for (Answer answer : answers) {
    			answer.setQuestion(this);
    		}
    	}

    	public void addAnswer(Answer answer) {
    		answers.add(answer);
    		answer.setQuestion(this);
    	}

    	...
~~~~~


One note: since we wanted to have here a bi-directional relation, we had to have lines: #12-#14 and #19.
Now, how to load answers? One way is to simply write a service method that returns `List<Answer>` filtered and ordered anyhow you need them, or to simply load them in provided `Question`. If you do not need to have sorted or filtered list, you can simply invoke: `AppDao#findRelated(Answer.class, question)`. See relations & hints for more details.

## many-to-1 relations

On the parent side (here: `Answer`) you can do everything as for 1-1 relation:
map FK and add set/get methods in the same manner. On the child side (here: `Question`)
you have to manage this relations as already said in above note.

##  many-to-many relations

There is nothing special in Db for many-to-many relations.
Just simply write services/dao methods that returns whatever you need.
If you want to use template-sql then you have to map the 'middle' table.
Of course, you can split this relation to two 1-to-many; but this is completely up to you.

In Uphea, we have this situation between `Question` and `User`, where user may have many
favorite questions. We have `Favorites` entity since we use template-sql.
