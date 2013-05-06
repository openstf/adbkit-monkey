Api = require './api'
Command = require './command'

class Multi extends Api
  constructor: (@monkey) ->
    @commands = []
    @replies = []
    @errors = []
    @counter = 0
    @sent = false
    @callback = null
    @collector = (err, result, cmd) =>
      @errors.push "#{cmd}: #{err.message}" if err
      @replies.push result
      @counter -= 1
      this._maybeFinish()

  _maybeFinish: ->
    if @counter is 0
      if @errors.length
        setImmediate =>
          @callback new Error @errors.join ', '
      else
        setImmediate =>
          @callback null, @replies
    return

  _forbidReuse: ->
    if @sent
      throw new Error "Reuse not supported"

  send: (command) ->
    this._forbidReuse()
    @commands.push new Command command, @collector
    return

  execute: (callback) ->
    this._forbidReuse()
    @counter = @commands.length
    @sent = true
    @callback = callback
    if @counter is 0
      return
    parts = []
    for command in @commands
      @monkey.commandQueue.enqueue command
      parts.push command.command
    parts.push ''
    @commands = []
    @monkey.stream.write parts.join '\n'
    return

module.exports = Multi
