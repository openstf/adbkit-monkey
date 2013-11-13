Api = require './api'
Command = require './command'
Reply = require './reply'
Queue = require './queue'
Multi = require './multi'
Parser = require './parser'

class Client extends Api
  constructor: ->
    @commandQueue = new Queue
    @parser = new Parser
    @stream = null

  _hook: ->
    @stream.on 'data', (data) =>
      @parser.parse data
    @stream.on 'error', (err) =>
      this.emit 'error', err
    @stream.on 'end', =>
      this.emit 'end'
    @stream.on 'finish', =>
      this.emit 'finish'
    @parser.on 'reply', (reply) =>
      this._consume reply
    @parser.on 'error', (err) =>
      this.emit 'error', err
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

  connect: (@stream) ->
    this._hook()
    return this

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

module.exports = Client
