class Reply
  @ERROR = 'ERROR'
  @OK = 'OK'

  constructor: (@type, @value) ->

  isError: ->
    @type is Reply.ERROR

  toError: ->
    unless this.isError()
      throw new Error 'toError() cannot be called for non-errors'
    new Error @value

module.exports = Reply
