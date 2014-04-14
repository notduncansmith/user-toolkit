class Extendable
  @moduleKeywords = ['extended', 'included']
  
  @includeClassProperties: (obj) ->
    for key, value of obj when key not in @moduleKeywords
      @[key] = value

    obj.extended?.apply(@)
    this

  @includeInstanceProperties: (obj) ->
    for key, value of obj when key not in @moduleKeywords
      # Assign properties to the prototype
      @::[key] = value

    obj.included?.apply(@)
    this

  @extend: (obj) ->
    @includeClassProperties obj.classProperties
    @includeInstanceProperties obj.instanceProperties

module.exports = Extendable