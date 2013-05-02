{expect} = require 'chai'

Queue = require '../../src/monkey/queue'
Command = require '../../src/monkey/command'

describe 'Queue', ->

  describe "when empty", ->

    before (done) ->
      @queue = new Queue
      done()

    it "should have null tail and tail", (done) ->
      expect(@queue.tail).to.be.null
      expect(@queue.head).to.be.null
      done()

    it "dequeue should return null", (done) ->
      expect(@queue.dequeue()).to.be.null
      done()

  describe "with one command", ->

    before (done) ->
      @queue = new Queue
      @command = new Command 'a', ->
      @queue.enqueue @command
      done()

    it "should have the command as head", (done) ->
      expect(@queue.head).to.equal @command
      done()

    it "should have tail same as head", (done) ->
      expect(@queue.head).to.equal @queue.tail
      done()

    it "should have command.next be null", (done) ->
      expect(@command.next).to.be.null
      done()

    it "dequeue should return the command and update tail and head", (done) ->
      expect(@queue.dequeue()).to.equal @command
      expect(@queue.head).to.be.null
      expect(@queue.tail).to.be.null
      done()

  describe "with multiple commands", ->

    before (done) ->
      @queue = new Queue
      @command1 = new Command 'a', ->
      @command2 = new Command 'b', ->
      @command3 = new Command 'c', ->
      @queue.enqueue @command1
      @queue.enqueue @command2
      @queue.enqueue @command3
      done()

    it "should set head to the first command", (done) ->
      expect(@queue.head).to.equal @command1
      done()

    it "should set tail to the last command", (done) ->
      expect(@queue.tail).to.equal @command3
      done()

    it "should set command.next properly", (done) ->
      expect(@command1.next).to.equal @command2
      expect(@command2.next).to.equal @command3
      expect(@command3.next).to.be.null
      done()

    it "dequeue should return the first command and update head", (done) ->
      expect(@queue.dequeue()).to.equal @command1
      expect(@command1.next).to.be.null
      expect(@queue.head).to.equal @command2
      done()
