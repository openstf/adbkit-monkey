import { expect } from 'chai'

import Parser from '../../lib/monkey/parser.js'

describe('Parser', () => {
  it("should emit 'wait' when waiting for more data", done => {
    const parser = new Parser()
    parser.on('wait', done)
    parser.parse(Buffer.from('OK'))
  })

  it("should emit 'drain' when all data has been consumed", done => {
    const parser = new Parser()
    parser.on('drain', done)
    parser.parse(Buffer.from('OK\n'))
  })

  it('should parse a successful reply', done => {
    const parser = new Parser()
    parser.on('reply', reply => {
      expect(reply.type).to.equal('OK')
      expect(reply.value).to.be.null
      expect(reply.isError()).to.equal(false)
      done()
    })
    parser.parse(Buffer.from('OK\n'))
  })

  it('should parse a successful reply with value', done => {
    const parser = new Parser()
    parser.on('reply', reply => {
      expect(reply.type).to.equal('OK')
      expect(reply.value).to.equal('2')
      done()
    })
    parser.parse(Buffer.from('OK:2\n'))
  })

  it('should parse a successful reply with spaces in value', done => {
    const parser = new Parser()
    parser.on('reply', reply => {
      expect(reply.type).to.equal('OK')
      expect(reply.value).to.equal('a b c')
      done()
    })
    parser.parse(Buffer.from('OK:a b c\n'))
  })

  it('should parse an empty successful reply', done => {
    const parser = new Parser()
    parser.on('reply', reply => {
      expect(reply.type).to.equal('OK')
      expect(reply.value).to.equal('')
      done()
    })
    parser.parse(Buffer.from('OK:\n'))
  })

  it('should not trim values in successful replies', done => {
    const parser = new Parser()
    parser.on('reply', reply => {
      expect(reply.type).to.equal('OK')
      expect(reply.value).to.equal(' test ')
      done()
    })
    parser.parse(Buffer.from('OK: test \n'))
  })

  it('should not trim values in error replies', done => {
    const parser = new Parser()
    parser.on('reply', reply => {
      expect(reply.type).to.equal('ERROR')
      expect(reply.value).to.equal(' test ')
      done()
    })
    parser.parse(Buffer.from('ERROR: test \n'))
  })

  it('should parse an error reply with value', done => {
    const parser = new Parser()
    parser.on('reply', reply => {
      expect(reply.type).to.equal('ERROR')
      expect(reply.value).to.equal('unknown var')
      expect(reply.isError()).to.equal(true)
      expect(reply.toError()).to.be.an.instanceof(Error)
      expect(reply.toError().message).to.equal('unknown var')
      done()
    })
    parser.parse(Buffer.from('ERROR:unknown var\n'))
  })

  it('should throw a SyntaxError for an unknown reply', done => {
    const parser = new Parser()
    parser.on('error', err => {
      expect(err).to.be.an.instanceOf(SyntaxError)
      done()
    })
    parser.parse(Buffer.from('FOO:bar\n'))
  })

  it('should parse multiple replies from one chunk', done => {
    const parser = new Parser()
    parser.once('reply', reply => {
      expect(reply.type).to.equal('OK')
      expect(reply.value).to.equal('2')
      parser.once('reply', reply => {
        expect(reply.type).to.equal('OK')
        expect(reply.value).to.equal('okay')
        done()
      })
    })
    parser.parse(Buffer.from('OK:2\nOK:okay\n'))
  })
})
