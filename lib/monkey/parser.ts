import { EventEmitter } from 'events'
import Reply from './reply'

class Parser extends EventEmitter {
  private column = 0
  private buffer = Buffer.alloc(0)

  public parse(chunk: Buffer): void {
    this.buffer = Buffer.concat([this.buffer, chunk])
    while (this.column < this.buffer.length) {
      if (this.buffer[this.column] === 0x0a) {
        this._parseLine(this.buffer.subarray(0, this.column))
        this.buffer = this.buffer.subarray(this.column + 1)
        this.column = 0
      }
      this.column += 1
    }
    if (this.buffer.length) {
      this.emit('wait')
    } else {
      this.emit('drain')
    }
  }

  private _parseLine(line: Buffer): void {
    switch (line[0]) {
      case 0x4f: // 'O'
        if (line.length === 2) {
          // 'OK'
          this.emit('reply', new Reply(Reply.OK, null))
        } else {
          // 'OK:'
          this.emit('reply', new Reply(Reply.OK, line.toString('ascii', 3)))
        }
        break
      case 0x45: // 'E'
        if (line.length === 5) {
          // 'ERROR'
          this.emit('reply', new Reply(Reply.ERROR, null))
        } else {
          // 'ERROR:'
          this.emit('reply', new Reply(Reply.ERROR, line.toString('ascii', 6)))
        }
        break
      default:
        this._complain(line)
    }
  }

  private _complain(line: Buffer): void {
    this.emit('error', new SyntaxError(`Unparseable line '${line}'`))
  }
}

export = Parser
