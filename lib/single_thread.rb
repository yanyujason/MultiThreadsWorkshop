require 'thread'
require '../lib/sleep_queue'
require '../lib/processor'

queue = SleepQueue.new [1,2,3]
processor = Processor.new

thread = Thread.new do
  while !queue.empty?
    data = queue.pop
    processor.process data
  end
  p "finished!"
end

thread.join
