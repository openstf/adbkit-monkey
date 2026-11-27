import { NetConnectOpts } from 'net'
import { Duplex } from 'stream'
import Client from './monkey/client'
import Connection from './monkey/connection'

class Monkey {
  public static Connection = Connection
  public static Client = Client

  static connect(options: NetConnectOpts): Connection {
    return new Connection().connect(options)
  }

  static connectStream(stream: Duplex): Client {
    return new Client().connect(stream)
  }
}

export = Monkey
