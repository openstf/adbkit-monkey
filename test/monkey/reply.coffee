{expect} = require 'chai'

Reply = require '../../src/monkey/reply'

describe 'Reply', ->

  it "should parse a successful reply", (done) ->
    [reply] = Reply.parse new Buffer 'OK\n'
    expect(reply.type).to.equal 'OK'
    expect(reply.value).to.be.null
    expect(reply.isError()).to.equal false
    done()

  it "should parse a successful reply with value", (done) ->
    [reply] = Reply.parse new Buffer 'OK:2\n'
    expect(reply.type).to.equal 'OK'
    expect(reply.value).to.equal '2'
    [reply] = Reply.parse new Buffer 'OK:a b c\n'
    expect(reply.type).to.equal 'OK'
    expect(reply.value).to.equal 'a b c'
    done()

  it "should parse an empty successful reply", (done) ->
    [reply] = Reply.parse new Buffer 'OK:\n'
    expect(reply.type).to.equal 'OK'
    expect(reply.value).to.equal ''
    done()

  it "should not trim parsed values", (done) ->
    [reply] = Reply.parse new Buffer 'OK: test \n'
    expect(reply.type).to.equal 'OK'
    expect(reply.value).to.equal ' test '
    [reply] = Reply.parse new Buffer 'ERROR: test \n'
    expect(reply.type).to.equal 'ERROR'
    expect(reply.value).to.equal ' test '
    done()

  it "should parse an error reply with value", (done) ->
    [reply] = Reply.parse new Buffer 'ERROR:unknown var\n'
    expect(reply.type).to.equal 'ERROR'
    expect(reply.value).to.equal 'unknown var'
    expect(reply.isError()).to.equal true
    expect(reply.toError()).to.be.an.instanceof Error
    expect(reply.toError().message).to.equal 'unknown var'
    done()

  it "should throw a SyntaxError on valueless error reply", (done) ->
    expect(-> Reply.parse new Buffer 'ERROR\n').to.throw SyntaxError
    done()

  it "should throw a SyntaxError for an unknown reply", (done) ->
    expect(-> Reply.parse new Buffer 'FOO:bar\n').to.throw SyntaxError
    done()

  it "should parse multiple replies from one chunk", (done) ->
    [reply, chunk] = Reply.parse new Buffer 'OK:2\nOK:okay\n'
    expect(reply.type).to.equal 'OK'
    expect(reply.value).to.equal '2'
    [reply, chunk] = Reply.parse chunk
    expect(reply.type).to.equal 'OK'
    expect(reply.value).to.equal 'okay'
    expect(chunk.length).to.equal 0
    done()
