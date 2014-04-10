auth = require '../authentication/auth'
di = require('omni-di')()
Promise = require './fake_promise'

class User
  constructor: ->
    @username = 'notduncansmith'
    @hashedPassword = 'hash'

db = 
  where: ->
    then: (func) ->
      func new User()

bcrypt =
  hash: (str, rounds, cb)->
    cb null, 'hash'
  hashThrowingError: (str, rounds, cb) ->
    cb new Error('ONOEZ'), null
  compare: (str, hash, cb) ->
    authenticated = str is 'hash'
    cb null, authenticated
  compareThrowingError: (str, hash, cb) ->
    cb new Error('ONOEZ'), null

di.register 'Promise', Promise
di.register 'db', db
di.register 'bcrypt', bcrypt

Auth = di.inject auth


describe 'The authentication module', ->

  # Make sure it will interface well with the User module
  it 'should have an authenticate class method', ->
    expect Auth.classProperties.authenticate
    .toEqual jasmine.any(Function)

  it 'should have a newPassword instance method', ->
    expect Auth.instanceProperties.newPassword
    .toEqual jasmine.any(Function)


  describe 'has a method called authenticate, which', ->

    it 'should return a promise', ->
      promise = Auth.classProperties.authenticate 'foo', 'bar'
      expect promise
      .toEqual jasmine.any(Promise)

    it 'should resolve with an error message if the passwords do not match', ->
      promise = Auth.classProperties.authenticate 'foo', 'bar'
      expect promise.value()
      .toEqual jasmine.any(String)

    it 'should resolve with a user object if the passwords match', ->
      promise = Auth.classProperties.authenticate 'foo', 'hash'
      expect promise.value()
      .toEqual jasmine.any(User)

    it 'should reject with an error message if the comparison fails', ->
      bcrypt.compare = bcrypt.compareThrowingError
      promise = Auth.classProperties.authenticate 'foo', 'hash'
      
      expect promise.reason()
      .toEqual jasmine.any(Error)

  describe 'has a method called newPassword, which', ->

    it 'should return a promise', ->
      promise = Auth.instanceProperties.newPassword 'foo'
      expect promise
      .toEqual jasmine.any(Promise)

    it 'should resolve with a hashed password', ->
      promise = Auth.instanceProperties.newPassword 'foo'
      expect promise.value()
      .toEqual 'hash'

    it 'should reject with an error message if the password creation fails', ->
      bcrypt.hash = bcrypt.hashThrowingError
      promise = Auth.instanceProperties.newPassword 'foo'
      
      expect promise.reason()
      .toEqual jasmine.any(Error)

