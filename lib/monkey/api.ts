import { EventEmitter } from 'events'
import { MonkeyCallback } from '../MonkeyCallback'

/** An Android key code, either as a number or as a name such as `KEYCODE_HOME`. */
type KeyCode = number | string

class Api extends EventEmitter {
  public send(
    // eslint-disable-next-line @typescript-eslint/no-unused-vars
    commands: string | string[],
    // eslint-disable-next-line @typescript-eslint/no-unused-vars
    callback?: MonkeyCallback
  ): unknown {
    throw new Error('send is not implemented')
  }

  public keyDown(keyCode: KeyCode, callback?: MonkeyCallback): this {
    this.send(`key down ${keyCode}`, callback)
    return this
  }

  public keyUp(keyCode: KeyCode, callback?: MonkeyCallback): this {
    this.send(`key up ${keyCode}`, callback)
    return this
  }

  public touchDown(x: number, y: number, callback?: MonkeyCallback): this {
    this.send(`touch down ${x} ${y}`, callback)
    return this
  }

  public touchUp(x: number, y: number, callback?: MonkeyCallback): this {
    this.send(`touch up ${x} ${y}`, callback)
    return this
  }

  public touchMove(x: number, y: number, callback?: MonkeyCallback): this {
    this.send(`touch move ${x} ${y}`, callback)
    return this
  }

  public trackball(dx: number, dy: number, callback?: MonkeyCallback): this {
    this.send(`trackball ${dx} ${dy}`, callback)
    return this
  }

  public flipOpen(callback?: MonkeyCallback): this {
    this.send('flip open', callback)
    return this
  }

  public flipClose(callback?: MonkeyCallback): this {
    this.send('flip close', callback)
    return this
  }

  public wake(callback?: MonkeyCallback): this {
    this.send('wake', callback)
    return this
  }

  public tap(x: number, y: number, callback?: MonkeyCallback): this {
    this.send(`tap ${x} ${y}`, callback)
    return this
  }

  public press(keyCode: KeyCode, callback?: MonkeyCallback): this {
    this.send(`press ${keyCode}`, callback)
    return this
  }

  public type(str: string, callback?: MonkeyCallback): this {
    // Escape double quotes.
    str = str.replace(/"/g, '\\"')
    if (str.indexOf(' ') === -1) {
      this.send(`type ${str}`, callback)
    } else {
      this.send(`type "${str}"`, callback)
    }
    return this
  }

  public list(callback: MonkeyCallback<string[]>): this {
    this.send('listvar', (err, vars) => {
      if (err) {
        callback(err)
      } else {
        callback(null, (vars as string).split(/\s+/g))
      }
    })
    return this
  }

  public get(name: string, callback?: MonkeyCallback): this {
    this.send(`getvar ${name}`, callback)
    return this
  }

  public quit(callback?: MonkeyCallback): this {
    this.send('quit', callback)
    return this
  }

  public done(callback?: MonkeyCallback): this {
    this.send('done', callback)
    return this
  }

  public sleep(ms: number, callback?: MonkeyCallback): this {
    this.send(`sleep ${ms}`, callback)
    return this
  }

  public getAmCurrentAction(callback?: MonkeyCallback): this {
    this.get('am.current.action', callback)
    return this
  }

  public getAmCurrentCategories(callback?: MonkeyCallback): this {
    this.get('am.current.categories', callback)
    return this
  }

  public getAmCurrentCompClass(callback?: MonkeyCallback): this {
    this.get('am.current.comp.class', callback)
    return this
  }

  public getAmCurrentCompPackage(callback?: MonkeyCallback): this {
    this.get('am.current.comp.package', callback)
    return this
  }

  public getAmCurrentData(callback?: MonkeyCallback): this {
    this.get('am.current.data', callback)
    return this
  }

  public getAmCurrentPackage(callback?: MonkeyCallback): this {
    this.get('am.current.package', callback)
    return this
  }

  public getBuildBoard(callback?: MonkeyCallback): this {
    this.get('build.board', callback)
    return this
  }

  public getBuildBrand(callback?: MonkeyCallback): this {
    this.get('build.brand', callback)
    return this
  }

  public getBuildCpuAbi(callback?: MonkeyCallback): this {
    this.get('build.cpu_abi', callback)
    return this
  }

  public getBuildDevice(callback?: MonkeyCallback): this {
    this.get('build.device', callback)
    return this
  }

  public getBuildDisplay(callback?: MonkeyCallback): this {
    this.get('build.display', callback)
    return this
  }

  public getBuildFingerprint(callback?: MonkeyCallback): this {
    this.get('build.fingerprint', callback)
    return this
  }

  public getBuildHost(callback?: MonkeyCallback): this {
    this.get('build.host', callback)
    return this
  }

  public getBuildId(callback?: MonkeyCallback): this {
    this.get('build.id', callback)
    return this
  }

  public getBuildManufacturer(callback?: MonkeyCallback): this {
    this.get('build.manufacturer', callback)
    return this
  }

  public getBuildModel(callback?: MonkeyCallback): this {
    this.get('build.model', callback)
    return this
  }

  public getBuildProduct(callback?: MonkeyCallback): this {
    this.get('build.product', callback)
    return this
  }

  public getBuildTags(callback?: MonkeyCallback): this {
    this.get('build.tags', callback)
    return this
  }

  public getBuildType(callback?: MonkeyCallback): this {
    this.get('build.type', callback)
    return this
  }

  public getBuildUser(callback?: MonkeyCallback): this {
    this.get('build.user', callback)
    return this
  }

  public getBuildVersionCodename(callback?: MonkeyCallback): this {
    this.get('build.version.codename', callback)
    return this
  }

  public getBuildVersionIncremental(callback?: MonkeyCallback): this {
    this.get('build.version.incremental', callback)
    return this
  }

  public getBuildVersionRelease(callback?: MonkeyCallback): this {
    this.get('build.version.release', callback)
    return this
  }

  public getBuildVersionSdk(callback?: MonkeyCallback): this {
    this.get('build.version.sdk', callback)
    return this
  }

  public getClockMillis(callback?: MonkeyCallback): this {
    this.get('clock.millis', callback)
    return this
  }

  public getClockRealtime(callback?: MonkeyCallback): this {
    this.get('clock.realtime', callback)
    return this
  }

  public getClockUptime(callback?: MonkeyCallback): this {
    this.get('clock.uptime', callback)
    return this
  }

  public getDisplayDensity(callback?: MonkeyCallback): this {
    this.get('display.density', callback)
    return this
  }

  public getDisplayHeight(callback?: MonkeyCallback): this {
    this.get('display.height', callback)
    return this
  }

  public getDisplayWidth(callback?: MonkeyCallback): this {
    this.get('display.width', callback)
    return this
  }
}

export = Api
