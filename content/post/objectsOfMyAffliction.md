+++
title = "The Objects of My Affliction"
date = "2016-08-02T12:02:51-06:00"

+++

Javascript objects are a cozy bunch.  To define an object in javascript in the most basic, literal sense, you would write:

```javascript
var myObject = {};
```

Keys and values may then be defined with bracket or dot-notation syntax, and objects are all instantiations of the parent `Object` of which it inherits other methods and properties.  This syntax for displaying objects in Javascript has helped me to understand how objects are
organized in other programming languages.

To a beginner, there are very easy-to-grasp similarities between the two languages.  Both have number and string datatypes, as well as similar syntax.  In both languages, arrays are designated with square brackets `[]` and in general share similar properties.  However, Python utilizes curly (mustache?) brackets to denote a collection called a dictionary.

Again - on the surface, and especially to a beginner, there seems to be virtually no difference between Javascript's objects and Python's dictionaries.  Both are collections of key: value pairs - separated by commas with a colon between the key and value.  Take a look at this object in Javascript:

```javascript
var myObject = {'foo': 'bar'};
myObject['foo'] // =>'bar'
```

...and then this dictionary in Python:

```python
my_dictionary = {'foo': 'bar'};
my_dictionary['foo'] // => 'bar'
```

The differences here are cosmetic - Javascript requires the var keyword to declare a variable (kind of) whereas this is not required in Python.  Also, convention states that Javascript uses camel case where Python uses underscores.  But the initialization and retrieval of key: value pairs is almost identical.

But are Python dictionaries objects?  Technically, everything is an object in Python, but dictionaries !== objects in Javascript.  Here's another example of a small difference.  In Python, we can set a variable as a key in a dictionary:

```python
i = 'k'
j = 1
dict = {i: j}
dict['k'] // => 1
dict[i] // => 1
```

...but trying the same thing in Javascript...

```javascript
var i = 'k'
var j = 1
var obj = {i: j}
obj['k'] // => undefined
obj[i] // => undefined
obj['i'] // => 1
```

Note that accessing `dict['i']` would return undefined in Python, since it would be looking for the string `'i'` as a key.  In Javascript, object keys are stored as strings and must be passed in as such when accessing with bracket notation.  Here is another example that exemplifies this.

In javascript, we can declare a literal object like so:

```javascript
var obj = {name: 'Nathan'}
console.log(obj) // => [object Object] {name: 'Nathan'}
console.log(obj['name']) // => 'Nathan'
```

But in python we would get an error:

```python
>>> obj = {name: 'Nathan'}
Traceback (most recent call last):
  File "<input>", line 1, in <module>
NameError: name  'name' is not defined
```

We get the error because the variable name is undefined, so Python raises the `NameError` when given the key to obj.  In Javascript's literal object notation, the keys within the brackets are converted to string datatypes.  We are now getting to the core of the difference between Javascript objects and Python dictionaries - which is, well, that Javascript objects are objects with properties and methods, which can inherit from parent objects and be used as a prototype for child objects.  Python dictionaries are more akin to mapped lists, in which each key can store a pointer or piece of data.  Both languages use bracket notation as constructors for these respective datatypes - and though they look similar, they vary greatly in their behaviors.  Here is one parting example, showing how Javascript objects can contain methods while Python dictionaries can store functions but not invoke them:

Javascript:

```javascript
var obj = {
  name: 'Nathan',
  myName: function() {return obj.name;}
};

console.log(obj.myName()) // => 'Nathan'
```

We can call the method `myName` with dot notation, which returns the property `name` in obj. However in python:

```python
def func():
  return dict['name']

dict = {
  'name': 'Nathan',
  'myName': func
}

dict['myName'] // => <function func at 0x100756f28>
```

Accessing `myName` in dict gives us a pointer to the function we declared earlier in the code.  It is not an object method, and thus cannot be invoked the same way we could in Javascript.  The object literal notation is a very convenient way to create and manipulate objects within Javascript, but it's important to recognize that it is also an abstract datatype, and the brackets are just a symbol to denote its data.
