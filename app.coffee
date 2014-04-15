# Dependencies
uuid = require 'node-uuid'
mysql = require 'mysql'
di = require('omni-di')()
Promise = require 'bluebird'
bcrypt = require 'bcrypt'

# Classes & Mixins
Extendable = require './base/extendable'
BaseClass = require './base/base'
RepoClass = require './base/repo'

PersistableMixin = require './base/persistable'
AuthMixin = require './authentication/auth'
RolesMixin = require './roles/roles'

module.exports = (config) ->

  exampleConfig = 
    db: 
      host: 'localhost'
      user: 'root'
      password: 'kffnnpa'
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

  # Set up repos
  Repo = di.inject RepoClass

  repositories = [
    'user',
    'user_role',
    'role'
  ]

  for r in repositories
    newRepo = new Repo config
    newRepo.table = r
    di.register "#{r}Repo", newRepo


  # Set up mixins
  Persistable = di.inject PersistableMixin
  di.register 'Persistable', Persistable

  Auth = di.inject AuthMixin
  di.register 'Auth', Auth

  Roles = di.inject RolesMixin
  di.register 'Roles', Roles

  User = di.inject BaseClass