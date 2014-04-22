require 'thread'
require '../lib/sleep_queue'
require '../lib/processor'
require '../lib/semaphore.rb'

queue = SleepQueue.new [1,2,3,4,5,6,7,8,9]
processor = Processor.new

mutex = Mutex.new
max = 2

semaphore = Semaphore.new(max)

resource = ConditionVariable.new

thread_number = 5

threads = []

thread_number.times do |x|
  threads << Thread.new do
    loop do
      semaphore.synchronize do
        data = 0
        mutex.synchronize do
          if !queue.empty?
            data = queue.pop
          else
            resource.wait mutex
          end
        end
        processor.processing data, x if data != 0
      end
    end
  end
end

producer = Thread.new do
  begin
    loop do
      num = Random.rand 100
      mutex.synchronize do
        queue.push num
        resource.broadcast
      end
      processor.produce_data num
    end
  rescue => e
    p e
  end
end

threads.each do |x|
  x.join
end

producer.join
