Net = require 'net'
{expect} = require 'chai'

Monkey = require '../'
Connection = require '../src/monkey/connection'
Stream = require '../src/monkey/stream'
MockDuplex = require './mock/duplex'

describe 'Monkey', ->

  describe 'connect(options)', ->

    before (done) ->
      @port = 16609
      @server = Net.createServer()
      @server.listen @port, done

    it "should return a Connection instance", (done) ->
      monkey = Monkey.connect port: @port
      expect(monkey).to.be.an.instanceOf Connection
      done()

    it "should pass options to Connection", (done) ->
      options = port: @port
      monkey = Monkey.connect options
      expect(monkey.options).to.equal options
      done()

    after (done) ->
      @server.close()
      done()

  describe 'connectStream(stream)', ->

    before (done) ->
      @duplex = new MockDuplex
      done()

    it "should return a Stream instance", (done) ->
      monkey = Monkey.connectStream @duplex
      expect(monkey).to.be.an.instanceOf Stream
      done()

    it "should pass stream to Stream", (done) ->
      monkey = Monkey.connectStream @duplex
      expect(monkey.stream).to.equal @duplex
      done()
