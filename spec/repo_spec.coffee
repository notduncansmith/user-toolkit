Promise = require './fake_promise'
RepoClass = require '../base/repo'
# Fake connection needs to return one value or many
# This lets us test automatic single value extraction

connection = 
  query: (sql, values, cb) ->
    if typeof values is 'function'
      cb = values

    if sql is 'foo'
      cb undefined, ['bar']
    else if sql is 'foos'
      cb undefined, ['bar', 'baz']
    else
      e = new Error('Something broke!')
      cb e, null
  
  release: ->

pool = 
  getConnection: (cb) ->
    cb null, connection

config = 
  table: 'users'

Repo = RepoClass(Promise, pool, config)
repo = new Repo()

user = 
  firstName: 'Duncan'

describe 'The user repository', ->

  beforeEach ->
    spyOn connection, 'query'
    .andCallThrough()

    spyOn connection, 'release'
    .andCallThrough()

    repo.query 'foo'
    repo.query 'foos'

  it 'should gracefully handle database errors', ->
    spyOn repo, 'handleError'
    .andCallThrough()

    # This will throw an error 
    # due to the way we defined the fake connection.query
    repo.save user

    expect repo.handleError
    .toHaveBeenCalled()

  it 'should modify the correct table', ->
    expect repo.table
    .toEqual config.table

  it 'should execute queries', ->
    expect connection.query
    .toHaveBeenCalledWith 'foo', jasmine.any(Function)

  it 'should release connections after use', ->
    expect connection.release
    .toHaveBeenCalled()

  it 'should return promises from queries', ->
    expect repo.query('foo')
    .toEqual jasmine.any(Promise)

  it 'should resolve it\'s promise with a value when the database returns one result', ->
    expect repo.query('foo').value()
    .toEqual 'bar'

  it 'should resolve it\'s promise with an array when the database res', ->
    expect repo.query('foos').value()
    .toEqual ['bar','baz']

  it 'should reject it\'s promise if the database returns an error', ->
    expect repo.query('onoez').reason()
    .toEqual jasmine.any(Error)

  it 'should call query with an object if it is passed one', ->
    repo.query 'foo', {}

    expect connection.query
    .toHaveBeenCalledWith 'foo', {}, jasmine.any(Function)


  describe 'when using the save method', ->

    beforeEach ->
      spyOn repo, 'query'
      .andCallThrough()

      spyOn repo, 'handleError'
      .andCallThrough()

      repo.save user


  









