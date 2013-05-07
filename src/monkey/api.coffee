{EventEmitter} = require 'events'

class Api extends EventEmitter
  send: ->
    throw new Error "send is not implemented"

  keyDown: (keyCode, callback) ->
    this.send "key down #{keyCode}", callback
    return this

  keyUp: (keyCode, callback) ->
    this.send "key up #{keyCode}", callback
    return this

  touchDown: (x, y, callback) ->
    this.send "touch down #{x} #{y}", callback
    return this

  touchUp: (x, y, callback) ->
    this.send "touch up #{x} #{y}", callback
    return this

  touchMove: (x, y, callback) ->
    this.send "touch move #{x} #{y}", callback
    return this

  trackball: (dx, dy, callback) ->
    this.send "trackball #{dx} #{dy}", callback
    return this

  flipOpen: (callback) ->
    this.send "flip open", callback
    return this

  flipClose: (callback) ->
    this.send "flip close", callback
    return this

  wake: (callback) ->
    this.send "wake", callback
    return this

  tap: (x, y, callback) ->
    this.send "tap #{x} #{y}", callback
    return this

  press: (keyCode, callback) ->
    this.send "press #{keyCode}", callback
    return this

  type: (str, callback) ->
    # Escape double quotes.
    str = str.replace /"/g, '\\"'
    if str.indexOf(' ') is -1
      this.send "type #{str}", callback
    else
      this.send "type \"#{str}\"", callback
    return this

  list: (callback) ->
    this.send "listvar", (err, vars) =>
      return this callback err if err
      if err
        callback err
      else
        callback null, vars.split /\s+/g
    return this

  get: (name, callback) ->
    this.send "getvar #{name}", callback
    return this

  quit: (callback) ->
    this.send "quit", callback
    return this

  done: (callback) ->
    this.send "done", callback
    return this

  sleep: (ms, callback) ->
    this.send "sleep #{ms}", callback
    return this

  getAmCurrentAction: (callback) ->
    this.get 'am.current.action', callback
    return this

  getAmCurrentCategories: (callback) ->
    this.get 'am.current.categories', callback
    return this

  getAmCurrentCompClass: (callback) ->
    this.get 'am.current.comp.class', callback
    return this

  getAmCurrentCompPackage: (callback) ->
    this.get 'am.current.comp.package', callback
    return this

  getAmCurrentData: (callback) ->
    this.get 'am.current.data', callback
    return this

  getAmCurrentPackage: (callback) ->
    this.get 'am.current.package', callback
    return this

  getBuildBoard: (callback) ->
    this.get 'build.board', callback
    return this

  getBuildBrand: (callback) ->
    this.get 'build.brand', callback
    return this

  getBuildCpuAbi: (callback) ->
    this.get 'build.cpu_abi', callback
    return this

  getBuildDevice: (callback) ->
    this.get 'build.device', callback
    return this

  getBuildDisplay: (callback) ->
    this.get 'build.display', callback
    return this

  getBuildFingerprint: (callback) ->
    this.get 'build.fingerprint', callback
    return this

  getBuildHost: (callback) ->
    this.get 'build.host', callback
    return this

  getBuildId: (callback) ->
    this.get 'build.id', callback
    return this

  getBuildManufacturer: (callback) ->
    this.get 'build.manufacturer', callback
    return this

  getBuildModel: (callback) ->
    this.get 'build.model', callback
    return this

  getBuildProduct: (callback) ->
    this.get 'build.product', callback
    return this

  getBuildTags: (callback) ->
    this.get 'build.tags', callback
    return this

  getBuildType: (callback) ->
    this.get 'build.type', callback
    return this

  getBuildUser: (callback) ->
    this.get 'build.user', callback
    return this

  getBuildVersionCodename: (callback) ->
    this.get 'build.version.codename', callback
    return this

  getBuildVersionIncremental: (callback) ->
    this.get 'build.version.incremental', callback
    return this

  getBuildVersionRelease: (callback) ->
    this.get 'build.version.release', callback
    return this

  getBuildVersionSdk: (callback) ->
    this.get 'build.version.sdk', callback
    return this

  getClockMillis: (callback) ->
    this.get 'clock.millis', callback
    return this

  getClockRealtime: (callback) ->
    this.get 'clock.realtime', callback
    return this

  getClockUptime: (callback) ->
    this.get 'clock.uptime', callback
    return this

  getDisplayDensity: (callback) ->
    this.get 'display.density', callback
    return this

  getDisplayHeight: (callback) ->
    this.get 'display.height', callback
    return this

  getDisplayWidth: (callback) ->
    this.get 'display.width', callback
    return this

module.exports = Api
