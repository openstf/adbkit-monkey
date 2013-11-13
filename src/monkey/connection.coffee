Net = require 'net'

Client = require './client'

class Connection extends Client
  connect: (options) ->
    stream = Net.connect options
    stream.setNoDelay true
    super stream

  _hook: ->
    @stream.on 'connect', =>
      this.emit 'connect'
    @stream.on 'close', (hadError) =>
      this.emit 'close', hadError
    super()

module.exports = Connection
