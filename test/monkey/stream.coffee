Sinon = require 'sinon'
Chai = require 'chai'
Chai.use require 'sinon-chai'
{expect} = Chai

Stream = require '../../src/monkey/stream'
Api = require '../../src/monkey/api'
Multi = require '../../src/monkey/multi'
MockDuplex = require '../mock/duplex'

describe 'Stream', ->

  beforeEach ->
    @duplex = new MockDuplex
    @monkey = new Stream @duplex

  it "should implement Api", (done) ->
    expect(@monkey).to.be.an.instanceOf Api
    done()

  it "should set 'stream' property", (done) ->
    expect(@monkey.stream).to.be.equal @duplex
    done()

  describe "events", ->

    it "should emit 'finish' when underlying stream does", (done) ->
      @monkey.on 'finish', ->
        done()
      @duplex.end()

    it "should emit 'end' when underlying stream does", (done) ->
      @monkey.on 'end', ->
        done()
      @duplex.on 'write', =>
        @duplex.respond 'OK\n'
        @monkey.end()
      @monkey.send 'foo', ->

  describe "end", ->

    it "should be chainable", (done) ->
      expect(@monkey.end()).to.equal @monkey
      done()

    it "should end underlying stream", (done) ->
      @duplex.on 'finish', ->
        done()
      @monkey.end()

  describe "send", ->

    it "should be chainable", (done) ->
      expect(@monkey.send 'foo', ->).to.equal @monkey
      done()

    describe "with single command", ->

      it "should receive reply", (done) ->
        @duplex.on 'write', (chunk) =>
          expect(chunk.toString()).to.equal 'give5\n'
          @duplex.respond 'OK:5\n'
          @monkey.end()
        callback = Sinon.spy()
        @monkey.send 'give5', callback
        @duplex.on 'finish', ->
          expect(callback).to.have.been.calledOnce
          expect(callback).to.have.been.calledWith null, '5', 'give5'
          done()

    describe "with multiple commands", ->

      it "should receive multiple replies", (done) ->
        @duplex.on 'write', (chunk) =>
          expect(chunk.toString()).to.equal 'give5\ngiveError\ngive7\n'
          @duplex.respond 'OK:5\nERROR:foo\nOK:7\n'
          @monkey.end()
        callback = Sinon.spy()
        @monkey.send ['give5', 'giveError', 'give7'], callback
        @duplex.on 'finish', ->
          expect(callback).to.have.been.calledThrice
          expect(callback).to.have.been.calledWith null, '5', 'give5'
          expect(callback).to.have.been.calledWith \
            Sinon.match.instanceOf(Error), null, 'giveError'
          expect(callback).to.have.been.calledWith null, '7', 'give7'
          done()

  describe "multi", ->

    it "should return a Multi instance", (done) ->
      expect(@monkey.multi()).to.be.an.instanceOf Multi
      done()

    it "should be connected to the same stream", (done) ->
      multi = @monkey.multi()
      expect(multi.stream).to.equal @monkey.stream
      done()

    it "should use the same command queue", (done) ->
      multi = @monkey.multi()
      expect(multi.commandQueue).to.equal @monkey.commandQueue
      done()
