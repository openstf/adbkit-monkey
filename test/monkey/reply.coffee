{expect} = require 'chai'

Reply = require '../../src/monkey/reply'

describe 'Reply', ->

  describe 'isError()', ->

    it "should return false for OK reply", (done) ->
      reply = new Reply Reply.OK, null
      expect(reply.isError()).to.equal false
      done()

    it "should return true for ERROR reply", (done) ->
      reply = new Reply Reply.ERROR, null
      expect(reply.isError()).to.equal true
      done()

  describe 'toError()', ->

    it "should throw an Error is called on an OK reply", (done) ->
      reply = new Reply Reply.OK, null
      expect(-> reply.toError()).to.throw Error
      done()

    it "should return an Error with the value as the message", (done) ->
      reply = new Reply Reply.ERROR, 'a b'
      err = reply.toError()
      expect(err).to.be.an.instanceOf Error
      expect(err.message).to.equal 'a b'
      done()
