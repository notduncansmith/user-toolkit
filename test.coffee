User = require('./app')()

User.find '11af0ba8-4f6f-4949-926a-9c848ec988e2'
.then (user) ->
  console.log user.roles