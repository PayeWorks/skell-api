require File.expand_path '../../helper.rb', __FILE__

require 'minitest/benchmark'

describe "PayeAPPLICATION-NAME API Bench" do

  describe "v1.0" do
    bench_performance_linear "pong message", 0.9999 do |n|
      n.times do
        get '/api/v1/ping'
        last_response.body.must_include 'pong'
      end
    end
  end

end
