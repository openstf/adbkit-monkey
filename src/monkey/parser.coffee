{EventEmitter} = require 'events'

Reply = require './reply'

class Parser extends EventEmitter
  constructor: (options) ->
    @column = 0
    @buffer = new Buffer ''

  parse: (chunk) ->
    @buffer = Buffer.concat [@buffer, chunk]
    while @column < @buffer.length
      if @buffer[@column] is 0x0a
        this._parseLine @buffer.slice 0, @column
        @buffer = @buffer.slice @column + 1
        @column = 0
      @column += 1
    if @buffer.length
      @emit 'wait'
    else
      @emit 'drain'
    return

  _parseLine: (line) ->
    switch line[0]
      when 0x4f # 'O'
        if line.length is 2 # 'OK'
          @emit 'reply', new Reply Reply.OK, null
        else # 'OK:'
          @emit 'reply', new Reply Reply.OK, line.toString('ascii', 3)
      when 0x45 # 'E'
        if line.length is 5 # 'ERROR'
          @emit 'reply', new Reply Reply.ERROR, null
        else # 'ERROR:'
          @emit 'reply', new Reply Reply.ERROR, line.toString('ascii', 6)
      else
        this._complain line
    return

  _complain: (line) ->
    @emit 'error', new SyntaxError "Unparseable line '#{line}'"
    return

module.exports = Parser
