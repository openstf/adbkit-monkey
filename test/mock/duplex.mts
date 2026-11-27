import stream from 'stream'

class MockDuplex extends stream.Duplex {
  _read(/*size*/) {}

  _write(chunk, encoding, callback) {
    this.emit('write', chunk, encoding, callback)
    callback(null)
  }

  causeRead(chunk) {
    if (!Buffer.isBuffer(chunk)) {
      chunk = Buffer.from(chunk)
    }
    this.push(chunk)
    this.push(null)
  }
}

export default MockDuplex
