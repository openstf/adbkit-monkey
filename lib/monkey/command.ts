import { MonkeyCallback } from '../MonkeyCallback'

class Command {
  public next: Command | null = null

  constructor(
    public command: string,
    public callback?: MonkeyCallback
  ) {}
}

export = Command
