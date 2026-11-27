import Net, { NetConnectOpts } from 'net'
import Client from './client'

class Connection extends Client {
  /** Opens a TCP connection with `net.connect()` and attaches to it. */
  public connect(options: NetConnectOpts): this
  /**
   * Connection takes `net.connect()` options where Client takes a stream,
   * which is not a type-safe override. This signature only keeps Connection
   * assignable to Client; nothing can be passed to it.
   */
  public connect(options: never): this
  public connect(options: NetConnectOpts): this {
    const stream = Net.connect(options)
    stream.setNoDelay(true)
    return super.connect(stream)
  }

  protected _hook(): void {
    const stream = this.stream as Net.Socket
    stream.on('connect', () => {
      this.emit('connect')
    })
    stream.on('close', hadError => {
      this.emit('close', hadError)
    })
    super._hook()
  }
}

export = Connection
