import sinon from 'sinon'
import * as chai from 'chai'
import sinonChai from 'sinon-chai'

chai.use(sinonChai)
const expect = chai.expect

import Client from '../../lib/monkey/client.js'
import Api from '../../lib/monkey/api.js'
import Multi from '../../lib/monkey/multi.js'
import MockDuplex from '../mock/duplex.mts'

describe('Client', () => {
  let duplex
  let monkey

  beforeEach(() => {
    duplex = new MockDuplex()
    monkey = new Client().connect(duplex)
  })

  it('should implement Api', done => {
    expect(monkey).to.be.an.instanceOf(Api)
    done()
  })

  describe('events', () => {
    it("should emit 'finish' when underlying stream does", done => {
      monkey.on('finish', () => {
        done()
      })
      duplex.end()
    })

    it("should emit 'end' when underlying stream does", done => {
      monkey.on('end', () => {
        done()
      })
      duplex.on('write', () => {
        duplex.causeRead('OK\n')
        monkey.end()
      })
      monkey.send('foo', () => {})
    })
  })

  describe('connect(stream)', () => {
    it("should set 'stream' property", done => {
      expect(monkey.stream).to.be.equal(duplex)
      done()
    })
  })

  describe('end()', () => {
    it('should be chainable', done => {
      expect(monkey.end()).to.equal(monkey)
      done()
    })

    it('should end underlying stream', done => {
      duplex.on('finish', () => {
        done()
      })
      monkey.end()
    })
  })

  describe('send(command, callback)', () => {
    it('should be chainable', done => {
      expect(monkey.send('foo', () => {})).to.equal(monkey)
      done()
    })

    describe('with single command', () => {
      it('should receive reply', done => {
        duplex.on('write', chunk => {
          expect(chunk.toString()).to.equal('give5\n')
          duplex.causeRead('OK:5\n')
          monkey.end()
        })
        const callback = sinon.spy()
        monkey.send('give5', callback)
        duplex.on('finish', () => {
          expect(callback).to.have.been.calledOnce
          expect(callback).to.have.been.calledWith(null, '5', 'give5')
          done()
        })
      })
    })

    describe('with multiple commands', () => {
      it('should receive multiple replies', done => {
        duplex.on('write', chunk => {
          expect(chunk.toString()).to.equal('give5\ngiveError\ngive7\n')
          duplex.causeRead('OK:5\nERROR:foo\nOK:7\n')
          monkey.end()
        })
        const callback = sinon.spy()
        monkey.send(['give5', 'giveError', 'give7'], callback)
        duplex.on('finish', () => {
          expect(callback).to.have.been.calledThrice
          expect(callback).to.have.been.calledWith(null, '5', 'give5')
          expect(callback).to.have.been.calledWith(
            sinon.match.instanceOf(Error),
            null,
            'giveError'
          )
          expect(callback).to.have.been.calledWith(null, '7', 'give7')
          done()
        })
      })
    })
  })

  describe('multi()', () => {
    it('should return a Multi instance', done => {
      expect(monkey.multi()).to.be.an.instanceOf(Multi)
      done()
    })

    it('should be be bound to the Client instance', done => {
      const multi = monkey.multi()
      expect(multi.monkey).to.equal(monkey)
      done()
    })
  })
})
