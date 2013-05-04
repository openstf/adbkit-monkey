Stream = require 'stream'

class MockDuplex extends Stream.Duplex
  _read: (size) ->

  _write: (chunk, encoding, callback) ->
    @emit 'write', chunk, encoding, callback
    callback null
    return

  respond: (chunk) ->
    unless Buffer.isBuffer chunk
      chunk = new Buffer chunk
    this.push chunk
    this.push null
    return

###
stream = new MockDuplex()
stream.on 'readable', ->
  console.log 'read', stream.read()
stream.on 'write', ->
  console.log 'respond'
  stream.respond 'OK'
stream.on 'close', ->
  console.log 'close'
stream.write 'a'
stream.on 'end', ->
  console.log 'end'
stream.on 'finish', ->
  console.log 'finish'
debugger
stream.end()
###

module.exports = MockDuplex
