class Reply {
  public static ERROR = 'ERROR'
  public static OK = 'OK'

  constructor(
    public type: string,
    public value: string | null
  ) {}

  public isError(): boolean {
    return this.type === Reply.ERROR
  }

  public toError(): Error {
    if (!this.isError()) {
      throw new Error('toError() cannot be called for non-errors')
    }
    // A null value gives the message "null", as it always has.
    return new Error(this.value as string)
  }
}

export = Reply
