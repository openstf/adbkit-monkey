Stream = require './monkey/stream'
Connection = require './monkey/connection'

class Monkey

  @connect: (options) ->
    new Connection().connect options

  @connectStream: (stream) ->
    new Stream().connect stream

Monkey.Connection = Connection
Monkey.Stream = Stream

module.exports = Monkey
