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

templates = 
  hello: 
    subject: 'Ohai'
    template: 'Message'

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

  describe 'has a sendWithTemplate method, which', ->

    beforeEach ->
      spyOn email, 'send'
      spyOn email, 'renderTemplate'
      .andCallThrough()

      email.sendWithTemplate user, 'hello', {package: 'pony'}, 'sometag'

    it 'should call send properly', ->
      expect email.send
      .toHaveBeenCalledWith user, 'Ohai', 'Message', 'sometag'

    it 'should call renderTemplate properly', ->
      expect email.renderTemplate
      .toHaveBeenCalledWith templates.hello.template, {user: user, package: 'pony'}

  describe 'has a renderTemplate method, which', ->

    it 'should return a promise', ->
      e = email.renderTemplate '', {}
      expect e
      .toEqual jasmine.any(Promise)

    it 'should use mustache to render the template', ->
      spyOn mustache, 'render'
      .andCallThrough()

      email.renderTemplate 'Template', {data: 'somedata'}
      
      expect mustache.render
      .toHaveBeenCalledWith 'Template', {data: 'somedata'}

    it 'should resolve with a rendered template', ->
      e = email.renderTemplate 'Template', {data: 'somedata'}
      expect e.value()
      .toEqual 'Message'





