Api = require './api'
Command = require './command'
Reply = require './reply'
Queue = require './queue'
Multi = require './multi'
Parser = require './parser'

class Stream extends Api
  constructor: (@stream) ->
    @commandQueue = new Queue
    @parser = new Parser
    this._hook()

  _hook: ->
    @stream.on 'readable', =>
      @parser.parse @stream.read()
    @stream.on 'error', (err) =>
      this.emit 'error', err
    @stream.on 'end', =>
      this.emit 'end'
    @stream.on 'finish', =>
      this.emit 'finish'
    @parser.on 'reply', (reply) =>
      this._consume reply
    @parser.on 'error', (err) =>
      throw err
    return

  _consume: (reply) ->
    if command = @commandQueue.dequeue()
      if reply.isError()
        command.callback reply.toError(), null, command.command
      else
        command.callback null, reply.value, command.command
    else
      throw new Error "Command queue depleted, but replies still coming in"
    return

  end: ->
    @stream.end()
    return this

  send: (commands, callback) ->
    if Array.isArray commands
      for command in commands
        @commandQueue.enqueue new Command command, callback
      @stream.write "#{commands.join('\n')}\n"
    else
      @commandQueue.enqueue new Command commands, callback
      @stream.write "#{commands}\n"
    return this

  multi: ->
    new Multi this

module.exports = Stream
