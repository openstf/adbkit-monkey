import sinon from 'sinon'
import * as chai from 'chai'
import sinonChai from 'sinon-chai'

chai.use(sinonChai)
const expect = chai.expect

import Api from '../../lib/monkey/api.js'

describe('Api', () => {
  let api

  beforeEach(() => {
    api = new Api()
    sinon.stub(api, 'send')
  })

  describe('keyDown(keyCode)', () => {
    it("should send a 'key down <keyCode>' command", done => {
      const callback = () => {}
      api.keyDown('a', callback)
      expect(api.send).to.have.been.calledWith('key down a', callback)
      done()
    })
  })

  describe('keyUp(keyCode)', () => {
    it("should send a 'key up <keyCode>' command", done => {
      const callback = () => {}
      api.keyUp('b', callback)
      expect(api.send).to.have.been.calledWith('key up b', callback)
      done()
    })
  })

  describe('touchDown(x, y)', () => {
    it("should send a 'touch down <x> <y>' command", done => {
      const callback = () => {}
      api.touchDown(6, 7, callback)
      expect(api.send).to.have.been.calledWith('touch down 6 7', callback)
      done()
    })
  })

  describe('touchUp(x, y)', () => {
    it("should send a 'touch up <x> <y>' command", done => {
      const callback = () => {}
      api.touchUp(97, 22, callback)
      expect(api.send).to.have.been.calledWith('touch up 97 22', callback)
      done()
    })
  })

  describe('touchMove(x, y)', () => {
    it("should send a 'touch move <x> <y>' command", done => {
      const callback = () => {}
      api.touchMove(27, 88, callback)
      expect(api.send).to.have.been.calledWith('touch move 27 88', callback)
      done()
    })
  })

  describe('trackball(dx, dy)', () => {
    it("should send a 'trackball <dx> <dy>' command", done => {
      const callback = () => {}
      api.trackball(90, 92, callback)
      expect(api.send).to.have.been.calledWith('trackball 90 92', callback)
      done()
    })
  })

  describe('flipOpen()', () => {
    it("should send a 'flip open' command", done => {
      const callback = () => {}
      api.flipOpen(callback)
      expect(api.send).to.have.been.calledWith('flip open', callback)
      done()
    })
  })

  describe('flipClose()', () => {
    it("should send a 'flip close' command", done => {
      const callback = () => {}
      api.flipClose(callback)
      expect(api.send).to.have.been.calledWith('flip close', callback)
      done()
    })
  })

  describe('wake()', () => {
    it("should send a 'wake' command", done => {
      const callback = () => {}
      api.wake(callback)
      expect(api.send).to.have.been.calledWith('wake', callback)
      done()
    })
  })

  describe('tap(x, y)', () => {
    it("should send a 'tap <x> <y>' command", done => {
      const callback = () => {}
      api.tap(6, 2, callback)
      expect(api.send).to.have.been.calledWith('tap 6 2', callback)
      done()
    })
  })

  describe('press(keyCode)', () => {
    it("should send a 'press <keyCode>' command", done => {
      const callback = () => {}
      api.press('c', callback)
      expect(api.send).to.have.been.calledWith('press c', callback)
      done()
    })
  })

  describe('type(string)', () => {
    it("should send a 'type <string>' command", done => {
      const callback = () => {}
      api.type('foo', callback)
      expect(api.send).to.have.been.calledWith('type foo', callback)
      done()
    })

    it('should wrap string in quotes if string contains spaces', done => {
      const callback = () => {}
      api.type('a b', callback)
      expect(api.send).to.have.been.calledWith('type "a b"', callback)
      done()
    })

    it("should escape double quotes with '\\'", done => {
      let callback = () => {}
      api.type('a"', callback)
      expect(api.send).to.have.been.calledWith('type a\\"', callback)
      callback = () => {}
      api.type('a" b"', callback)
      expect(api.send).to.have.been.calledWith('type "a\\" b\\""', callback)
      done()
    })
  })

  describe('list()', () => {
    it("should send a 'listvar' command", done => {
      api.list(() => {})
      // @todo Don't ignore the callback.
      expect(api.send).to.have.been.calledWith('listvar')
      done()
    })
  })

  describe('get(varname)', () => {
    it("should send a 'getvar <varname>' command", done => {
      const callback = () => {}
      api.get('foo', callback)
      expect(api.send).to.have.been.calledWith('getvar foo', callback)
      done()
    })
  })

  describe('quit()', () => {
    it("should send a 'quit' command", done => {
      const callback = () => {}
      api.quit(callback)
      expect(api.send).to.have.been.calledWith('quit', callback)
      done()
    })
  })

  describe('done()', () => {
    it("should send a 'done' command", done => {
      const callback = () => {}
      api.done(callback)
      expect(api.send).to.have.been.calledWith('done', callback)
      done()
    })
  })

  describe('sleep(<ms>)', () => {
    it("should send a 'sleep <ms>' command", done => {
      const callback = () => {}
      api.sleep(500, callback)
      expect(api.send).to.have.been.calledWith('sleep 500', callback)
      done()
    })
  })
})
