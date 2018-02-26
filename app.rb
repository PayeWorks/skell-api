require 'rack/cors'
require 'rack/deflater'
require 'rack/content_type'
require 'rack/contrib/response_headers'
require 'cuba'
require 'cuba/with'
require 'rack/parser'
require 'pg'
require 'sequel'
require 'scrivener'
require 'shield'
require 'ost'
require 'net/http'
require 'json'
require 'multi_json'
require 'rep'
require 'lupa'

# set default environment
ENV['RACK_ENV'] ||= 'development'

require 'pry' if ENV['RACK_ENV'] == 'development'
# Load Cuba.settings
require_relative 'config/settings'

$db = Sequel.connect(Cuba.settings['PG_DB_URL'], max_connections: 20)

Sequel::Model.plugin :timestamps, update_on_create: true
Sequel::Model.plugin :json_serializer

# database
redic_conn = Redic.new(Cuba.settings['DB_URI'])

# Background process
Ost.redis = redic_conn

# Require all application files.
Dir['./lib/**/*.rb'].sort.each                  { |rb| require rb }
Dir['./helpers/**/*.rb'].sort.each              { |rb| require rb }
Dir['./config/initializers/**/*.rb'].sort.each  { |rb| require rb }
Dir['./enumerations/**/*.rb'].sort.each         { |rb| require rb }
Dir['./models/**/*.rb'].sort.each               { |rb| require rb }
Dir['./routes/**/*.rb'].sort.each               { |rb| require rb }
Dir['./validators/**/*.rb'].sort.each           { |rb| require rb }
Dir['./services/**/*.rb'].sort.each             { |rb| require rb }
Dir['./serializers/**/*.rb'].sort.each          { |rb| require rb }
Dir['./searches/**/*.rb'].sort.each             { |rb| require rb }

# Load rack middlewares.
Cuba.use Rack::Deflater
Cuba.use Rack::ContentType, 'application/json'
Cuba.use Rack::MethodOverride
Cuba.use Rack::Head
Cuba.use Rack::Cors do
  allow do
    origins  '*'
    resource '*', headers: :any, methods: [:get, :post, :put, :delete, :options]
  end
end
Cuba.use Rack::Parser,
  parsers:  { 'application/json' => proc { |data| MultiJson.load(data) } },
  handlers: { %r(json) => proc { |err, type| [400, {}, ["Bad Request: #{err.to_s}"]] } }
Cuba.use Rack::ResponseHeaders do |headers|
  headers['X-Whoami']            ||= 'PayeAPPLICATION-NAME API'
  headers['X-PAYE-APPLICATION-NAME-VERSION'] ||= 'v1'
end

# Cuba Helpers.
Cuba.plugin APIHelpers
Cuba.plugin Cuba::With

# Finally, define the application routes.
Cuba.define do
  on 'api' do
    run APIRoutes
  end

  api_not_found!
end
