class Reply
  @ERROR = 'ERROR'
  @OK = 'OK'

  constructor: (@type, @value) ->

  isError: ->
    @type is 'ERROR'

  toError: ->
    new Error @value

module.exports = Reply
