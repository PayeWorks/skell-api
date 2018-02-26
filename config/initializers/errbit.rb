if ENV['RACK_ENV'] == 'production'

  require 'airbrake'

  Airbrake.configure do |config|
    config.host = Cuba.settings["ERRBIT_HOST"]
    config.project_id  = Cuba.settings["ERRBIT_PROJECT_ID"]
    config.project_key = Cuba.settings["ERRBIT_PROJECT_KEY"]
  end if Cuba.settings["ERRBIT_PROJECT_ID"]

end
