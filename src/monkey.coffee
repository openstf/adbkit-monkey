Client = require './monkey/client'
Connection = require './monkey/connection'

class Monkey

  @connect: (options) ->
    new Connection().connect options

  @connectStream: (stream) ->
    new Client().connect stream

Monkey.Connection = Connection
Monkey.Client = Client

module.exports = Monkey
