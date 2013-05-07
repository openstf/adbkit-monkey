Stream = require './monkey/stream'
Connection = require './monkey/connection'

class Monkey

  @connect: (options) ->
    new Connection options

  @connectStream: (stream) ->
    new Stream stream

module.exports = Monkey
