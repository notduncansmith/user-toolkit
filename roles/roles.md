We need the ability to create new Roles

Roles are first-class business objects

This means we should be able to create new roles programmatically:

```javascript
var role = new Role({name: 'Administrator'});
role.save();

console.log(role);
//=> {id: '1234', name: 'Administrator'}
```


However, we also need the ability to manipulate a user's roles.

These methods should exist on the User object:

```javascript

var user = new User(opts);

user.addRole('Administrator');
console.log(user.roles);

//=> [{id: '1234', name:'Administrator'}]

```

The caveat being that at this point, we need the end-developer to include not one, but TWO libraries: 

```javascript
var User = require('user-toolkit');
var Role = require('user-toolkit-role');

// OR

var User = require('user-toolkit');
var Role = User.Role;

```

Given that UTK is supposed to be a drop-in, the second would appear ideal.
However, by following the Grunt/Gulp plugin model, `require('user-toolkit-role')` feels more correct.

I want it to be a single package, so we'll just leave it at that.