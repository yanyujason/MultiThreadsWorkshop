require 'thread'
require '../lib/sleep_queue'
require '../lib/processor'
require '../lib/semaphore.rb'

queue = SleepQueue.new [1,2,3,4,5,6,7,8,9]
processor = Processor.new

mutex = Mutex.new
max = 2

semaphore = Semaphore.new(max)

thread_number = 5

threads = []

thread_number.times do |x|
  threads << Thread.new do
    loop do
      semaphore.synchronize do
        data = nil
        mutex.synchronize do
          if !queue.empty?
            data = queue.pop
          end
        end
        if !data.nil?
          processor.processing data, x
        else
          processor.no_data
        end
      end
    end
  end
end

threads.each do |x|
  x.join
end

#delete sleep 1 in pop method and add it after line 28 to make it more clear
