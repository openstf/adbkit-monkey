import { Duplex } from 'stream'
import Api from './api'
import Command from './command'
import Queue from './queue'
import Multi from './multi'
import Parser from './parser'
import Reply from './reply'
import { MonkeyCallback } from '../MonkeyCallback'

class Client extends Api {
  public commandQueue = new Queue()
  public parser = new Parser()
  public stream: Duplex | null = null

  protected _hook(): void {
    const stream = this.stream as Duplex
    stream.on('data', data => {
      this.parser.parse(data)
    })
    stream.on('error', err => {
      this.emit('error', err)
    })
    stream.on('end', () => {
      this.emit('end')
    })
    stream.on('finish', () => {
      this.emit('finish')
    })
    this.parser.on('reply', reply => {
      this._consume(reply)
    })
    this.parser.on('error', err => {
      this.emit('error', err)
    })
  }

  private _consume(reply: Reply): void {
    const command = this.commandQueue.dequeue()
    if (command) {
      // As before, a command sent without a callback throws once its reply
      // arrives.
      const callback = command.callback as MonkeyCallback
      if (reply.isError()) {
        callback(reply.toError(), null, command.command)
      } else {
        callback(null, reply.value, command.command)
      }
    } else {
      throw new Error('Command queue depleted, but replies still coming in')
    }
  }

  public connect(stream: Duplex): this {
    this.stream = stream
    this._hook()
    return this
  }

  public end(): this {
    ;(this.stream as Duplex).end()
    return this
  }

  public send(commands: string | string[], callback?: MonkeyCallback): this {
    const stream = this.stream as Duplex
    if (Array.isArray(commands)) {
      for (const command of commands) {
        this.commandQueue.enqueue(new Command(command, callback))
      }
      stream.write(`${commands.join('\n')}\n`)
    } else {
      this.commandQueue.enqueue(new Command(commands, callback))
      stream.write(`${commands}\n`)
    }
    return this
  }

  public multi(): Multi {
    return new Multi(this)
  }
}

export = Client
