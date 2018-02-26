module Ost
  class Queue
    def each_with_concurrency(size = 3, &block)
      concurrency = Array.new(size).map do |iteration|
        Thread.new(iteration) do |iteration|
          each(&block)
        end
      end
      concurrency.each(&:join)
    end
  end
end
