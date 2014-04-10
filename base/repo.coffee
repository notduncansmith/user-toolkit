# Data access layer for users

module.exports = (Promise, pool, config) ->

  class Repo
    constructor: ->
      @table = config.table

    save: (user) ->
      sql = "
      insert into #{@table} set ? 
      on duplicate key update ?
      "
      
      @query sql, [user, user]
      .catch @handleError('Unable to save user')

    where: (opt) ->
      sql = "select * from #{@table} where ?"

      @query sql, [opt]
      .catch @handleError('Unable to find user')


    query: (sql, values) ->
      p = new Promise (resolve, reject) ->
        pool.getConnection (error, connection) ->
          callback = (err, results) ->
            connection.release()
            if err?
              reject err
              return

            if results.length is 1
              resolve results[0]
            else
              resolve results

          if error?
            reject error
          else
            if values?
              q = connection.query sql, values, callback
            else
              q = connection.query sql, callback

    handleError: (msg) ->
      (err) -> 
        console.log "ONOEZ: #{msg}"
        console.log "#{err}"