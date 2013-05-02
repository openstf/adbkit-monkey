class Reply
  @ERROR = 'ERROR'
  @OK = 'OK'

  @parse: (chunk) ->
    unless Buffer.isBuffer chunk
      throw new Error "Only Buffers can be processed"
    length = chunk.length
    unless length
      return null
    split = -1
    # Detect the ':' value separator
    switch 0x3a
      when chunk[2] then split = 2
      when chunk[5] then split = 5
    end = split
    # Figure out where the line ends (i.e. '\n')
    while end < length and chunk[end] isnt 0x0a
      end += 1
    value = chunk.toString 'ascii', split + 1, end
    if split is -1
      type = value
      if type is Reply.ERROR
        throw new SyntaxError "ERROR must have a value"
      value = null
    else
      type = chunk.toString 'ascii', 0, split
    switch type
      when Reply.OK, Reply.ERROR
        return [new Reply(type, value), chunk.slice(end + 1)]
    throw new SyntaxError "Unknown response '#{chunk.toString 'ascii', 0, end}'"

  constructor: (@type, @value) ->

  isError: ->
    @type is 'ERROR'

  toError: ->
    new Error @value

module.exports = Reply
