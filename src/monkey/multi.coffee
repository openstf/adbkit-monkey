Api = require './api'

class Multi extends Api
  constructor: (@stream, @commandQueue) ->
    @commands = []
    @replies = []
    @errors = []
    @counter = 0
    @sent = false
    @callback = null
    @collector = (err, result, cmd) =>
      @errors.push "#{cmd}: #{err.message}" if err
      @replies.push result
      this.maybeFinish()

  maybeFinish: ->
    if @counter is 0
      if @errors.length
        setImmediate =>
          @callback new Error @errors.join ', '
      else
        setImmediate =>
          @callback null, @replies
    return

  send: (command) ->
    @commands = new Command command, @collector
    return

  execute: (callback) ->
    if @sent
      throw new Error "Reuse not supported"
    @counter = @commands.length
    @sent = true
    @callback = callback
    if @counter is 0
      return
    parts = []
    for command in @commands
      @commandQueue.enqueue command
      parts.push command.command
    parts.push ''
    @commands = []
    @stream.write parts.join '\n'
    return

module.exports = Multi
