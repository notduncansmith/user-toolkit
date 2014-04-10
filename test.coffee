User = require './app'

u = 
  firstName: 'Duncan'
  lastName: 'Smith'

user = new User u


console.log user.fullName()

user.newPassword 'secure'
.then (hash) ->
  console.log hash