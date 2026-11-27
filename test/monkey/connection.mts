import Net from 'net'
import sinon from 'sinon'
import * as chai from 'chai'
import sinonChai from 'sinon-chai'

chai.use(sinonChai)
const expect = chai.expect

import Connection from '../../lib/monkey/connection.js'
import Client from '../../lib/monkey/client.js'

describe('Connection', () => {
  const options = { port: 16610 }
  let server

  before(done => {
    server = Net.createServer()
    server.listen(options.port, done)
  })

  after(done => {
    server.close()
    done()
  })

  it('should extend Client', done => {
    const monkey = new Connection()
    expect(monkey).to.be.an.instanceOf(Client)
    done()
  })

  it('should not create a connection immediately', done => {
    const spy = sinon.spy(Net, 'connect')
    new Connection()
    expect(spy).to.not.have.been.called
    spy.restore()
    done()
  })

  describe('events', () => {
    it("should emit 'connect' when underlying stream does", done => {
      const monkey = new Connection().connect(options)
      monkey.on('connect', () => {
        monkey.end()
        done()
      })
    })
  })

  describe('connect(options)', () => {
    it('should create a connection', done => {
      const spy = sinon.spy(Net, 'connect')
      const monkey = new Connection().connect(options)
      expect(spy).to.have.been.calledWith(options)
      spy.restore()
      // Finish connecting before the server closes in after(), or the socket
      // fails with nothing listening for its error.
      monkey.on('connect', () => {
        monkey.end()
        done()
      })
    })
  })
})
