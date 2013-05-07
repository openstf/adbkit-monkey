{expect} = require 'chai'

Parser = require '../../src/monkey/parser'
Reply = require '../../src/monkey/reply'

describe 'Parser', ->

  it "should parse a successful reply", (done) ->
    parser = new Parser
    parser.on 'reply', (reply) ->
      expect(reply.type).to.equal 'OK'
      expect(reply.value).to.be.null
      expect(reply.isError()).to.equal false
      done()
    parser.parse new Buffer 'OK\n'

  it "should parse a successful reply with value", (done) ->
    parser = new Parser
    parser.on 'reply', (reply) ->
      expect(reply.type).to.equal 'OK'
      expect(reply.value).to.equal '2'
      done()
    parser.parse new Buffer 'OK:2\n'

  it "should parse a successful reply with spaces in value", (done) ->
    parser = new Parser
    parser.on 'reply', (reply) ->
      expect(reply.type).to.equal 'OK'
      expect(reply.value).to.equal 'a b c'
      done()
    parser.parse new Buffer 'OK:a b c\n'

  it "should parse an empty successful reply", (done) ->
    parser = new Parser
    parser.on 'reply', (reply) ->
      expect(reply.type).to.equal 'OK'
      expect(reply.value).to.equal ''
      done()
    parser.parse new Buffer 'OK:\n'

  it "should not trim values in successful replies", (done) ->
    parser = new Parser
    parser.on 'reply', (reply) ->
      expect(reply.type).to.equal 'OK'
      expect(reply.value).to.equal ' test '
      done()
    parser.parse new Buffer 'OK: test \n'

  it "should not trim values in error replies", (done) ->
    parser = new Parser
    parser.on 'reply', (reply) ->
      expect(reply.type).to.equal 'ERROR'
      expect(reply.value).to.equal ' test '
      done()
    parser.parse new Buffer 'ERROR: test \n'

  it "should parse an error reply with value", (done) ->
    parser = new Parser
    parser.on 'reply', (reply) ->
      expect(reply.type).to.equal 'ERROR'
      expect(reply.value).to.equal 'unknown var'
      expect(reply.isError()).to.equal true
      expect(reply.toError()).to.be.an.instanceof Error
      expect(reply.toError().message).to.equal 'unknown var'
      done()
    parser.parse new Buffer 'ERROR:unknown var\n'

  it "should throw a SyntaxError for an unknown reply", (done) ->
    parser = new Parser
    parser.on 'error', (err) ->
      expect(err).to.be.an.instanceOf SyntaxError
      done()
    parser.parse new Buffer 'FOO:bar\n'

  it "should parse multiple replies from one chunk", (done) ->
    parser = new Parser
    parser.once 'reply', (reply) ->
      expect(reply.type).to.equal 'OK'
      expect(reply.value).to.equal '2'
      parser.once 'reply', (reply) ->
        expect(reply.type).to.equal 'OK'
        expect(reply.value).to.equal 'okay'
        done()
    parser.parse new Buffer 'OK:2\nOK:okay\n'
