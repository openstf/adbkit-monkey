{expect} = require 'chai'

Reply = require '../../src/monkey/reply'

describe 'Reply', ->

  it "should parse a successful reply", (done) ->
    reply = Reply.parse 'OK'
    expect(reply.type).to.equal 'OK'
    expect(reply.value).to.be.null
    done()

  it "should parse a successful reply with value", (done) ->
    reply = Reply.parse 'OK:2'
    expect(reply.type).to.equal 'OK'
    expect(reply.value).to.equal '2'
    reply = Reply.parse 'OK:a b c'
    expect(reply.type).to.equal 'OK'
    expect(reply.value).to.equal 'a b c'
    done()

  it "should parse an empty successful reply", (done) ->
    reply = Reply.parse 'OK:'
    expect(reply.type).to.equal 'OK'
    expect(reply.value).to.equal ''
    done()

  it "should not trim parsed values", (done) ->
    reply = Reply.parse 'OK: test '
    expect(reply.type).to.equal 'OK'
    expect(reply.value).to.equal ' test '
    reply = Reply.parse 'ERROR: test '
    expect(reply.type).to.equal 'ERROR'
    expect(reply.value).to.equal ' test '
    done()

  it "should parse an error reply with value", (done) ->
    reply = Reply.parse 'ERROR:unknown var'
    expect(reply.type).to.equal 'ERROR'
    expect(reply.value).to.equal 'unknown var'
    done()

  it "should throw a SyntaxError on valueless error reply", (done) ->
    expect(-> Reply.parse 'ERROR').to.throw SyntaxError
    done()

  it "should throw a SyntaxError for an unknown reply", (done) ->
    expect(-> Reply.parse 'FOO:bar').to.throw SyntaxError
    done()
