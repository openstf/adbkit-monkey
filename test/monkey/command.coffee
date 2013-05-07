{expect} = require 'chai'

Command = require '../../src/monkey/command'

describe 'Command', ->

  it "should have a 'command' property set", (done) ->
    cmd = new Command 'a', ->
    expect(cmd.command).to.equal 'a'
    done()

  it "should have a 'callback' property set", (done) ->
    callback = ->
    cmd = new Command 'b', callback
    expect(cmd.callback).to.equal callback
    done()

  it "should have a 'next' property for the queue", (done) ->
    cmd = new Command 'c', ->
    expect(cmd.next).to.be.null
    done()
