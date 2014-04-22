require 'thread'
require '../lib/sleep_queue'
require '../lib/processor'

queue = SleepQueue.new [1,2,3,4,5,6,7,8]
processor = Processor.new

threads = []

5.times do |x|
  threads << Thread.new do
    loop do
      if !queue.empty?
        data = queue.pop
        processor.processing data, x
      end
    end
  end
end

threads.each do |x|
  x.join
end
