# j2j

Convert any **Files.json** to corresponding **Classe.java** files


## Installation

    $ gem install j2j

## Usage

    $ j2j ~/sample.json -o ~/destination_folder

> `sample.json`:

```json
{
  "total": 2,
  "people": [
    { "name": "jose" },
    { "name": "maria" }
  ]
}
```

Lets look at the `~/destination_folder`...

The files `Sample.java` and `Person.java` were created

> `Sample.java`:

```java
public class Sample {

  private Long total;
  private List<Person> people;

  public Long getTotal() { return total; }
  public void setTotal(Long total) { this.total = total; }
  public List<Person> getPerson() { return people; }
  public void setPerson(List<Person> people) { this.people = people; }

}
```

> `Person.java`:

```java
public class Person {

  private String name;

  public String getName() { return name; }
  public void setName(String name) { this.name = name; }

}
```

... and you're golden :)

# Advanced

| Param        | Shortcut  | Default value | Usage |
|:------------:|:---------:| :------------:|:------------|
| root_class   | -r        | Example.java  | $ **j2j ~/file.json -r Person** |
| package      | -p        | com.example   | $ **j2j ~/file.json -p com.company** |
| output       | -o        | out           | $ **j2j ~/file.json -o src/** |

Complete example:
> $ j2j ~/file.json -r Person -p com.compay -o src/


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/cesarferreira/j2j.

