import Net from 'net'
import { expect } from 'chai'

import Monkey from '../index.js'
import Connection from '../lib/monkey/connection.js'
import Client from '../lib/monkey/client.js'
import MockDuplex from './mock/duplex.mts'

describe('Monkey', () => {
  describe('Connection', () => {
    it('should be exposed', done => {
      expect(Monkey.Connection).to.equal(Connection)
      done()
    })
  })

  describe('Client', () => {
    it('should be exposed', done => {
      expect(Monkey.Client).to.equal(Client)
      done()
    })
  })

  describe('connect(options)', () => {
    const port = 16609
    let server

    before(done => {
      server = Net.createServer()
      server.listen(port, done)
    })

    it('should return a Connection instance', done => {
      const monkey = Monkey.connect({ port })
      expect(monkey).to.be.an.instanceOf(Connection)
      // Finish connecting before the server closes in after(), or the socket
      // fails with nothing listening for its error.
      monkey.on('connect', () => {
        monkey.end()
        done()
      })
    })

    after(done => {
      server.close()
      done()
    })
  })

  describe('connectStream(stream)', () => {
    let duplex

    before(done => {
      duplex = new MockDuplex()
      done()
    })

    it('should return a Client instance', done => {
      const monkey = Monkey.connectStream(duplex)
      expect(monkey).to.be.an.instanceOf(Client)
      done()
    })

    it('should pass stream to Client', done => {
      const monkey = Monkey.connectStream(duplex)
      expect(monkey.stream).to.equal(duplex)
      done()
    })
  })
})
