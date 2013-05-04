Net = require 'net'
Sinon = require 'sinon'
Chai = require 'chai'
Chai.use require 'sinon-chai'
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
    monkey = new Connection @options
    expect(monkey).to.be.an.instanceOf Stream
    done()

  it "should set 'options' property", (done) ->
    monkey = new Connection @options
    expect(monkey.options).to.equal @options
    done()

  it "should set 'stream' property", (done) ->
    monkey = new Connection @options
    expect(monkey.stream).to.be.an.instanceOf Net.Socket
    done()

  it "should create a connection", (done) ->
    Sinon.spy Net, 'connect'
    monkey = new Connection @options
    expect(Net.connect).to.have.been.calledWith @options
    Net.connect.restore()
    done()
