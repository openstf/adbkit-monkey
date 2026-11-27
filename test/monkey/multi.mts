import sinon from 'sinon'
import * as chai from 'chai'
import sinonChai from 'sinon-chai'

chai.use(sinonChai)
const expect = chai.expect

import Multi from '../../lib/monkey/multi.js'
import Client from '../../lib/monkey/client.js'
import MockDuplex from '../mock/duplex.mts'
import Api from '../../lib/monkey/api.js'

describe('Multi', () => {
  let duplex
  let monkey
  let multi

  beforeEach(() => {
    duplex = new MockDuplex()
    monkey = new Client().connect(duplex)
    multi = new Multi(monkey)
  })

  it('should implement Api', done => {
    expect(multi).to.be.an.instanceOf(Api)
    done()
  })

  it("should set 'monkey' property", done => {
    expect(multi.monkey).to.be.equal(monkey)
    done()
  })

  describe('send(command)', () => {
    it('should not write to stream', done => {
      sinon.spy(duplex, 'write')
      multi.send('foo')
      expect(duplex.write).to.not.have.been.called
      done()
    })

    it('should throw an Error if run after execute()', done => {
      sinon.spy(duplex, 'write')
      multi.execute(() => {})
      expect(() => multi.send('foo')).to.throw(Error)
      done()
    })
  })

  describe('execute(callback)', () => {
    it('should write to stream if commands were sent', done => {
      sinon.spy(duplex, 'write')
      multi.send('foo')
      multi.execute(() => {})
      expect(duplex.write).to.have.been.calledOnce
      done()
    })

    it('should not write to stream if commands were not sent', done => {
      sinon.spy(duplex, 'write')
      multi.execute(() => {})
      expect(duplex.write).to.not.have.been.called
      done()
    })

    it('should throw an Error if reused', done => {
      sinon.spy(duplex, 'write')
      multi.execute(() => {})
      expect(() => multi.execute(() => {})).to.throw(Error)
      done()
    })

    it('should write command to stream', done => {
      sinon.spy(duplex, 'write')
      multi.send('foo')
      multi.execute(() => {})
      expect(duplex.write).to.have.been.calledWith('foo\n')
      done()
    })

    it('should write multiple commands to stream at once', done => {
      sinon.spy(duplex, 'write')
      multi.send('tap 1 2')
      multi.send('getvar foo')
      multi.execute(() => {})
      expect(duplex.write).to.have.been.calledWith('tap 1 2\ngetvar foo\n')
      done()
    })

    describe('callback', () => {
      it('should be called just once with all results', done => {
        duplex.on('write', () => {
          duplex.causeRead('OK\nOK:bar\n')
        })
        multi.send('tap 1 2')
        multi.send('getvar foo')
        multi.execute((/*err, results*/) => {
          done()
        })
      })
    })
  })
})
