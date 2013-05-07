Net = require 'net'

Stream = require './stream'

class Connection extends Stream
  constructor: (@options) ->
    stream = Net.connect @options
    stream.setNoDelay true
    super stream

module.exports = Connection
