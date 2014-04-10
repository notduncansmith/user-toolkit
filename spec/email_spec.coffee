EmailClass = require '../email/email'
Promise = require './fake_promise'
di = require('omni-di')()


mailer = 
  messages:
    send: (msg, cb) ->
      cb(true)

mustache = 
  render: (template, data) ->
    'Message'

templates = ['Hello, {{name}}!']

mailConfig =
  fromEmail: 'from@bar.com'
  fromName: 'From Bar'

di.register 'Promise', Promise
di.register 'mailer', mailer
di.register 'mustache', mustache
di.register 'templates', templates
di.register 'mailConfig', mailConfig

Email = di.inject EmailClass

class User
  constructor: (@email, @firstName, @lastName) ->
  fullName: ->
    "#{@firstName} #{@lastName}"

email = new Email()

user = new User('foo@bar.com', 'Foo', 'Bar')

describe 'The Email module', ->

  describe 'has a send method, which', ->

    beforeEach ->
      spyOn mailer.messages, 'send'
      .andCallThrough()

      email.send user, 'Hello', 'Ohai', 'stuff'
      

    it 'should return a promise', ->
      p = email.send user, 'Subject', 'Message', 'stuff'
      expect p
      .toEqual jasmine.any(Promise)

    it 'should call mailer.messages.send', ->
      expect mailer.messages.send
      .toHaveBeenCalledWith jasmine.any(Object), jasmine.any(Function)