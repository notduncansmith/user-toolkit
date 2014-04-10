


# Strategy

User Toolkit is a collection of modules that provide common user management functionality to applications.


Each module adds some combination of instance methods, class methods, and attributes/columns to the User class, and may add its own tables to the database. This means that (aside from dependent modules) each module can be used individually. For example, one can have role management without email notifications.


All features are modules that follow a few common patterns:

- Modules that require database access contain mite scripts with all migrations necessary to operate
    
    Db columns and tables should be prefixed with 'ut_'

- Every module should expose an API for performing atomic actions

- Modules that can depend on 3rd party services (e.g. Mandrill) should use the Interface pattern, which exposes a collection of methods that the end-developer can implement by passing in their own functions. 
    
    These modules should come packaged with tests that will verify whether the implementation is correct. 

    Additionally, these modules should  always implement the functionality on their own, and come with support for at least one vendor. 

- All modules should emit events when significant things happen. 

- Modules can depend on other modules. 


# Features

* Default user table + class

* Authentication

- `4h` Email Notifications w/template support (external module)

- `4h` Password Reset

- `6h` Role Management

- `16h` Router (provides views + JSON API)

- `16h` Views (partials + barebones layout + Bootstrap)

- `8h` Preferences (implementation similar to Roles)

- `8h` Oauth (FB, Tw, G+ baked in)

- `4h` SSO (single sign-on) for above

- `6h` Activation/Deactivation (auto (default), manual, email + token)

- `8h` Paid Memberships




## User Class

Attributes/columns:

    ID (UUIDv4)
    First Name
    Last Name
    Email
    Street Address Line 1
    Street Address Line 2
    City
    State
    Zip

Class methods:

    User.create(user)
    User.find(email or ID) '*' will return all users
    User.update(user)
    User.delete(userId or user)

Instace methods:
    
    User.save()
    User.delete()



## Authentication

Adds no tables

Adds the following attributes:

    Username
    Password

Adds the following class methods:
    
    User.authenticate(username, attemptedPassword)

Adds the following instance methods:
    
    changePassword(newPassword)



## Role Management

Adds the following tables:

    ut_role
    ut_user_role

Adds the following class methods:
    
    User.createRole(roleName)
    User.deleteRole(roleName)
    User.renameRole(roleName)


Adds the following instance methods:

    getRoles()
    hasRole(roleName)
    addRole(roleName)
    removeRole(roleName)



## Email Notifications

These will be passed in via a javascript object of template objects:

Example config:

```javascript
{

    renderingEngine: Mustache, // this is the actual engine
    templates: [
        {
            name: 'password reset',
            template: 'Your new password is {{password}}'
        },
        {
            name: 'Welcome!'
            template: 'Congratulations {{user.firstName}}, you have signed up for {{appName}}!'
        }
    ]
}
```


This feels like something that should be database driven, but I don't like the idea of having to look templates up by ID. As a developer I want to pass in template names as strings since I know exactly which template I want to send. 

Plus, if the client wants to change one of their templates, we can (and should) bill for that. We're not doing Wordpress here.

Templates will use Handlebars.

Data passed in to `send` methods will automatically be extended with the user instance; thus, the final `data` object passed to the template would look something like this:

```javascript
{
    newFollower: '@notduncansmith',
    dateFollowed: 'today'
    user: {
        firstName: 'Stephen',
        lastName: 'Jones',
        // ...
    }
}
```

Adds the following class methods:

    User.sendEmail(userId, templateName, data)

Adds the following instance methods:
    
    sendEmail(templateName, data)



## Password Reset

Depends on:

    Authentication
    Email Notifications

Adds the following email template:
    
    password_reset.hbs

Adds the following instance methods:

    resetPassword()



## Oauth/SSO

Depends on:
    
    Authentication

Adds the following tables:

    ut_oauth
    ut_user_oauth

Adds the following attributes:

    facebookId
    twitterId
    gplusId

Adds the following class methods:

    User.oauthenticate(oauthService, oauthId)

Adds the following instance methods:
    
    linkFacebook
    linkTwitter
    linkGplus

Optionally adds the following routes:

    /oauth/twitter
    /oauth/facebook
    /oauth/gplus



## Activation/Deactivation

Depends on:
    
    Email Notifications

Adds the following attributes:

    enabled

Adds the following class methods:

    User.enable(userId)
    User.disable(userId)

Adds the following instance methods:

    enable()
    disable()