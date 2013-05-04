Sinon = require 'sinon'
Chai = require 'Chai'
Chai.use require 'sinon-chai'
{expect} = Chai

Api = require '../../src/monkey/api'

describe 'Api', ->

  beforeEach ->
    @api = new Api
    Sinon.stub @api, 'send'

  describe "keyDown(keyCode)", ->

    it "should send a 'key down <keyCode>' command", (done) ->
      @api.keyDown 'a', callback = ->
      expect(@api.send).to.have.been.calledWith 'key down a', callback
      done()

  describe "keyUp(keyCode)", ->

    it "should send a 'key up <keyCode>' command", (done) ->
      @api.keyUp 'b', callback = ->
      expect(@api.send).to.have.been.calledWith 'key up b', callback
      done()

  describe "touchDown(x, y)", ->

    it "should send a 'touch down <x> <y>' command", (done) ->
      @api.touchDown 6, 7, callback = ->
      expect(@api.send).to.have.been.calledWith 'touch down 6 7', callback
      done()

  describe "touchUp(x, y)", ->

    it "should send a 'touch up <x> <y>' command", (done) ->
      @api.touchUp 97, 22, callback = ->
      expect(@api.send).to.have.been.calledWith 'touch up 97 22', callback
      done()

  describe "touchMove(x, y)", ->

    it "should send a 'touch move <x> <y>' command", (done) ->
      @api.touchMove 27, 88, callback = ->
      expect(@api.send).to.have.been.calledWith 'touch move 27 88', callback
      done()

  describe "trackball(dx, dy)", ->

    it "should send a 'trackball <dx> <dy>' command", (done) ->
      @api.trackball 90, 92, callback = ->
      expect(@api.send).to.have.been.calledWith 'trackball 90 92', callback
      done()

  describe "flipOpen()", ->

    it "should send a 'flip open' command", (done) ->
      @api.flipOpen callback = ->
      expect(@api.send).to.have.been.calledWith 'flip open', callback
      done()

  describe "flipClose()", ->

    it "should send a 'flip close' command", (done) ->
      @api.flipClose callback = ->
      expect(@api.send).to.have.been.calledWith 'flip close', callback
      done()

  describe "wake()", ->

    it "should send a 'wake' command", (done) ->
      @api.wake callback = ->
      expect(@api.send).to.have.been.calledWith 'wake', callback
      done()

  describe "tap(x, y)", ->

    it "should send a 'tap <x> <y>' command", (done) ->
      @api.tap 6, 2, callback = ->
      expect(@api.send).to.have.been.calledWith 'tap 6 2', callback
      done()

  describe "press(keyCode)", ->

    it "should send a 'press <keyCode>' command", (done) ->
      @api.press 'c', callback = ->
      expect(@api.send).to.have.been.calledWith 'press c', callback
      done()

  describe "type(string)", ->

    it "should send a 'type <string>' command", (done) ->
      @api.type 'foo', callback = ->
      expect(@api.send).to.have.been.calledWith 'type foo', callback
      done()

    it "should wrap string in quotes if string contains spaces", (done) ->
      @api.type 'a b', callback = ->
      expect(@api.send).to.have.been.calledWith 'type "a b"', callback
      done()

    it "should escape double quotes with '\\'", (done) ->
      @api.type 'a"', callback = ->
      expect(@api.send).to.have.been.calledWith 'type a\\"', callback
      @api.type 'a" b"', callback = ->
      expect(@api.send).to.have.been.calledWith 'type "a\\" b\\""', callback
      done()

  describe "list()", ->

    it "should send a 'listvar' command", (done) ->
      @api.list callback = ->
      # @todo Don't ignore the callback.
      expect(@api.send).to.have.been.calledWith 'listvar'
      done()

  describe "get(varname)", ->

    it "should send a 'getvar <varname>' command", (done) ->
      @api.get 'foo', callback = ->
      expect(@api.send).to.have.been.calledWith 'getvar foo', callback
      done()

  describe "quit()", ->

    it "should send a 'quit' command", (done) ->
      @api.quit callback = ->
      expect(@api.send).to.have.been.calledWith 'quit', callback
      done()

  describe "done()", ->

    it "should send a 'done' command", (done) ->
      @api.done callback = ->
      expect(@api.send).to.have.been.calledWith 'done', callback
      done()

  describe "sleep(<ms>)", ->

    it "should send a 'sleep <ms>' command", (done) ->
      @api.sleep 500, callback = ->
      expect(@api.send).to.have.been.calledWith 'sleep 500', callback
      done()
