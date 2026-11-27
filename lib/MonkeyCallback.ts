/**
 * Called once monkey replies to a command. `err` is set when monkey answers
 * with `ERROR`, and `command` is the command the reply belongs to.
 */
export type MonkeyCallback<T = string | null> = (
  err: Error | null,
  value?: T,
  command?: string
) => void
