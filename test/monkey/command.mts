import { expect } from 'chai'

import Command from '../../lib/monkey/command.js'

describe('Command', () => {
  it("should have a 'command' property set", done => {
    const cmd = new Command('a', () => {})
    expect(cmd.command).to.equal('a')
    done()
  })

  it("should have a 'callback' property set", done => {
    const callback = () => {}
    const cmd = new Command('b', callback)
    expect(cmd.callback).to.equal(callback)
    done()
  })

  it("should have a 'next' property for the queue", done => {
    const cmd = new Command('c', () => {})
    expect(cmd.next).to.be.null
    done()
  })
})
