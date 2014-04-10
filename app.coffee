# Dependencies
uuid = require 'node-uuid'
mysql = require 'mysql'
di = require('omni-di')()
Promise = require 'bluebird'
bcrypt = require 'bcrypt'

# Classes
Extendable = require './base/extendable'
BaseClass = require './base/base'
RepoClass = require './base/repo'

module.exports = (config) ->

  exampleConfig = 
    db: 
      host: 'localhost'
      user: 'root'
      password: '1'
      connectionLimit: 500
      database: 'toolkit'
    table: 'user'

  config ?= exampleConfig

  pool = mysql.createPool config.db

  # Register dependencies
  di.register 'uuid', uuid
  di.register 'pool', pool
  di.register 'Promise', Promise
  di.register 'config', config
  di.register 'Extendable', Extendable
  di.register 'bcrypt', bcrypt

  # Set up repo
  Repo = di.inject RepoClass
  db = new Repo()
  di.register 'db', db


  # Set up modules
  Auth = require './authentication/auth'
  auth = di.inject Auth


  modules = [auth]
  di.register 'modules', modules


  # Power up User class
  User = di.inject BaseClass