{EventEmitter} = require 'events'

Command = require './command'
Reply = require './reply'
Queue = require './queue'
Multi = require './multi'

class Stream extends EventEmitter
  constructor: (@stream) ->
    @commandQueue = new Queue
    this._hook()

  _hook: ->
    @stream.on 'readable', =>
      this._consume @stream.read()
    @stream.on 'error', (err) =>
      this.emit 'error', err
    @stream.on 'end', =>
      this.emit 'end'
    @stream.on 'finish', =>
      this.emit 'finish'
    return

  _consume: (chunk) ->
    while parsed = Reply.parse chunk
      [reply, chunk] = parsed
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
    return

  send: (commands, callback) ->
    if Array.isArray commands
      for command in commands
        @commandQueue.enqueue new Command command, callback
      @stream.write "#{commands.join('\n')}\n"
    else
      @commandQueue.enqueue new Command commands, callback
      @stream.write "#{commands}\n"
    return

  multi: ->
    new Multi @stream, @commandQueue

module.exports = Stream
