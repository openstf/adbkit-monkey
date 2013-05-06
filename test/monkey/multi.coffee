Sinon = require 'sinon'
Chai = require 'Chai'
Chai.use require 'sinon-chai'
{expect} = Chai

Multi = require '../../src/monkey/multi'
Stream = require '../../src/monkey/stream'
MockDuplex = require '../mock/duplex'
Api = require '../../src/monkey/api'

describe 'Multi', ->

  beforeEach ->
    @duplex = new MockDuplex
    @monkey = new Stream @duplex
    @multi = new Multi @monkey

  it "should implement Api", (done) ->
    expect(@multi).to.be.an.instanceOf Api
    done()

  it "should set 'monkey' property", (done) ->
    expect(@multi.monkey).to.be.equal @monkey
    done()

  describe "send(command)", ->

    it "should not write to stream", (done) ->
      Sinon.spy @duplex, 'write'
      @multi.send 'foo'
      expect(@duplex.write).to.not.have.been.called
      done()

    it "should throw an Error if run after execute()", (done) ->
      Sinon.spy @duplex, 'write'
      @multi.execute ->
      expect(=> @multi.send 'foo').to.throw Error
      done()

  describe "execute(callback)", ->

    it "should write to stream if commands were sent", (done) ->
      Sinon.spy @duplex, 'write'
      @multi.send 'foo'
      @multi.execute ->
      expect(@duplex.write).to.have.been.calledOnce
      done()

    it "should not write to stream if commands were not sent", (done) ->
      Sinon.spy @duplex, 'write'
      @multi.execute ->
      expect(@duplex.write).to.not.have.been.called
      done()

    it "should throw an Error if reused", (done) ->
      Sinon.spy @duplex, 'write'
      @multi.execute ->
      expect(=> @multi.execute ->).to.throw Error
      done()

    it "should write command to stream", (done) ->
      Sinon.spy @duplex, 'write'
      @multi.send 'foo'
      @multi.execute ->
      expect(@duplex.write).to.have.been.calledWith 'foo\n'
      done()

    it "should write multiple commands to stream at once", (done) ->
      Sinon.spy @duplex, 'write'
      @multi.send 'tap 1 2'
      @multi.send 'getvar foo'
      @multi.execute ->
      expect(@duplex.write).to.have.been.calledWith 'tap 1 2\ngetvar foo\n'
      done()

    describe "callback", ->

      it "should be called just once with all results", (done) ->
        @duplex.on 'write', =>
          @duplex.respond 'OK\nOK:bar\n'
        @multi.send 'tap 1 2'
        @multi.send 'getvar foo'
        @multi.execute (err, results) ->
          done()
