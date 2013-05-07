Net = require 'net'
Path = require 'path'
Sinon = require 'sinon'
Chai = require 'chai'
Chai.use require 'sinon-chai'
{spawn} = require 'child_process'
{expect} = Chai

Connection = require '../../src/monkey/connection'
Stream = require '../../src/monkey/stream'

describe 'Connection', ->

  before (done) ->
    @options = port: 16610
    @server = Net.createServer()
    @server.listen @options.port, done

  after (done) ->
    @server.close()
    done()

  it "should extend Stream", (done) ->
    monkey = new Connection
    expect(monkey).to.be.an.instanceOf Stream
    done()

  it "should not create a connection immediately", (done) ->
    Sinon.spy Net, 'connect'
    monkey = new Connection
    expect(Net.connect).to.not.have.been.called
    Net.connect.restore()
    done()

  describe "events", ->

    it "should emit 'connect' when underlying stream does", (done) ->
      monkey = new Connection().connect @options
      monkey.on 'connect', ->
        done()

  describe 'connect(options)', ->

    it "should create a connection", (done) ->
      Sinon.spy Net, 'connect'
      monkey = new Connection().connect @options
      expect(Net.connect).to.have.been.calledWith @options
      Net.connect.restore()
      done()
