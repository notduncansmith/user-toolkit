# Fake promise class
# because using bluebird would mean real async
# and writing async tests is a pain in the ass

class Promise
  constructor: (func) ->
    @rejectionReason = null
    @valueValue = null
    self = this

    reject = (reason) ->
      self.setReason reason

    resolve = (value) ->
      self.setValue value

    func(resolve, reject)

  setReason: (reason) ->
    @rejectionReason = reason

  setValue: (value) ->
    @valueValue = value

  reason: ->
    @rejectionReason

  value :->
    @valueValue

  catch: (errHandler) ->
    errHandler 'Something broke!'

  then: (func) ->
    func(@valueValue)

module.exports = Promise