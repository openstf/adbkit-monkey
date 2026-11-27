import Api from './api'
import Command from './command'
import type Client from './client'
import { MonkeyCallback } from '../MonkeyCallback'

/** Called once with every reply, or with an error naming each failed command. */
type MultiCallback = (err: Error | null, replies?: (string | null)[]) => void

class Multi extends Api {
  public commands: Command[] = []
  public replies: (string | null)[] = []
  public errors: string[] = []
  public counter = 0
  public sent = false
  public callback: MultiCallback | null = null
  public collector: MonkeyCallback

  constructor(public monkey: Client) {
    super()
    this.collector = (err, result, cmd) => {
      if (err) {
        this.errors.push(`${cmd}: ${err.message}`)
      }
      this.replies.push(result as string | null)
      this.counter -= 1
      this._maybeFinish()
    }
  }

  private _maybeFinish(): void {
    if (this.counter === 0) {
      const callback = this.callback as MultiCallback
      if (this.errors.length) {
        setImmediate(() => {
          callback(new Error(this.errors.join(', ')))
        })
      } else {
        setImmediate(() => {
          callback(null, this.replies)
        })
      }
    }
  }

  private _forbidReuse(): void {
    if (this.sent) {
      throw new Error('Reuse not supported')
    }
  }

  // Commands are queued, and their replies collected, until execute(), so a
  // per-command callback is not supported.
  public send(command: string): void {
    this._forbidReuse()
    this.commands.push(new Command(command, this.collector))
  }

  public execute(callback: MultiCallback): void {
    this._forbidReuse()
    this.counter = this.commands.length
    this.sent = true
    this.callback = callback
    if (this.counter === 0) {
      return
    }
    const parts: string[] = []
    for (const command of this.commands) {
      this.monkey.commandQueue.enqueue(command)
      parts.push(command.command)
    }
    parts.push('')
    this.commands = []
    ;(this.monkey.stream as NonNullable<Client['stream']>).write(
      parts.join('\n')
    )
  }
}

export = Multi
