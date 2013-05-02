class Reply

  @parse: (data) ->
    unless data.length
      return null
    if Buffer.isBuffer data
      data = data.toString()
    split = data.indexOf ':'
    if split is -1
      switch data
        when 'OK'
          return new Reply 'OK', null
        when 'ERROR'
          throw new SyntaxError "ERROR must come with value"
        else
          throw new SyntaxError "Out-of-spec valueless reply: '#{data}'"
    type = data.substr 0, split
    value = data.substr split + 1
    switch type
      when 'OK', 'ERROR'
        return new Reply type, value
    throw new SyntaxError "Out-of-spec reply with value: '#{data}'"

  constructor: (@type, @value) ->

  isError: ->
    @type is 'ERROR'

  toError: ->
    new Error @value

module.exports = Reply
