import Command from './command'

class Queue {
  public head: Command | null = null
  public tail: Command | null = null

  public enqueue(item: Command): void {
    if (this.tail) {
      this.tail.next = item
    } else {
      this.head = item
    }
    this.tail = item
  }

  public dequeue(): Command | null {
    const item = this.head
    if (item) {
      if (item === this.tail) {
        this.tail = null
      }
      this.head = item.next
      item.next = null
    }
    return item
  }
}

export = Queue
