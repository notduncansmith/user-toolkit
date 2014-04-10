# Dependencies
Promise = require './fake_promise'
Extendable = require '../base/extendable'
di = require('omni-di')()

# The star of the show
BaseClass = require '../base/base'

# Fixtures
uuid = 
  v4: ->
    '1234'

opts = 
  firstName: 'Duncan'
  lastName: 'Smith'
  email: 'hello@duncanmsmith.com'
  streetOne: '123 Fake Street'
  streetTwo: 'Apartment 5'
  city: 'Birmingham'
  state: 'Alabama'
  zip: '35209'

db = 
  save: ->
  where: ->
    new Promise (resolve, reject) ->
      resolve opts

testModule = 
  instanceProperties:
    sayHi: -> console.log('Allo guvnah!')
  classProperties:
    noWay: -> console.log('Jose!')

modules = [testModule]

di.register 'uuid', uuid
di.register 'Extendable', Extendable
di.register 'modules', modules
di.register 'db', db

User = di.inject BaseClass


u = new User opts

describe 'The User class', ->
  
  beforeEach ->
    spyOn db, 'save'
    .andCallThrough()

    spyOn console, 'log'

    u.save()

    u.sayHi()
    User.noWay()

  it 'should render full names', ->
    fullName = u.fullName()
    expect(fullName).toEqual 'Duncan Smith'

  it 'should render full street addresses', ->
    fullAddress = u.fullAddress()
    expectedFull = 
    "
    123 Fake Street\n
    Apartment 5\n
    Birmingham, AL 35209
    "
    expect(fullAddress).toEqual expectedFull

  it 'should save to the database', ->
    expect db.save
    .toHaveBeenCalled()

  it 'should add an id if not instantiated with one', ->
    expect opts.id
    .toBe undefined

    expect u.id
    .toEqual jasmine.any(String)

  it 'should return user objects from the database', ->
    user = User.find u.id

    expect user instanceof User
    .toBe true

  it 'should be extendable with instance methods', ->
    expect console.log
    .toHaveBeenCalledWith 'Allo guvnah!'

  it 'should be extendable with class methods', ->
    expect console.log 
    .toHaveBeenCalledWith 'Jose!'