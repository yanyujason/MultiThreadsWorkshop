require 'thread'
require '../lib/sleep_queue'
require '../lib/processor'

queue = SleepQueue.new [1,2,3,4,5,6,7,8]
processor = Processor.new
mutex = Mutex.new

threads = []

5.times do |x|
  threads << Thread.new do
    while !queue.empty? do
      data = 0
      mutex.synchronize do
        if !queue.empty?
          data = queue.pop
        end
      end
      processor.processing data, x if data != 0
    end
  end
end

threads.each do |x|
  x.join
end
