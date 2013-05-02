class Command
  constructor: (@command, @callback) ->
    this.next = null

module.exports = Command
