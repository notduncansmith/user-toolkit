# Data access layer

module.exports = (Promise, pool, config) ->

  class Repo
    constructor: (table) ->
      @table = table or config.table

    save: (obj) ->
      sql = "
      insert into #{@table} set ? 
      on duplicate key update ?
      "
      
      @query sql, [obj, obj]
      .then -> obj
      .catch @handleError('Unable to save object')

    where: (opt) ->
      sql = "select * from #{@table} where ?"

      @query sql, [opt]
      .catch @handleError('Unable to find object')

    all: ->
      sql = "select * from #{@table}"

      @query sql
      .catch @handleError('Unable to find objects')    

    delete: (opt) ->
      sql = "delete * from #{@table} where ?"

      @query sql, [opt]
      .catch @handleError('Unable to remove object')


    query: (sql, values) ->
      p = new Promise (resolve, reject) ->
        pool.getConnection (error, connection) ->
          callback = (err, results) ->
            connection.release()
            if err?
              reject err
              return
            
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