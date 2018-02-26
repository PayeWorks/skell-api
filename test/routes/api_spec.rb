require File.expand_path '../../helper.rb', __FILE__

describe "PayeSAM API" do

  describe "v1.0" do

    it "should successfully return a pong" do
      get '/api/v1/ping'
      last_response.body.must_include 'pong'
    end

  end

end
