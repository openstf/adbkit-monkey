class Queue
  constructor: ->
    @head = null
    @tail = null

  enqueue: (item) ->
    if @tail
      @tail.next = item
    else
      @head = item
    @tail = item
    return

  dequeue: ->
    item = @head
    if item
      if item is @tail
        @tail = null
      @head = item.next
      item.next = null
    return item

module.exports = Queue
