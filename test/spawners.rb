require 'faker'
require 'securerandom'
require_relative 'spawn'

User.extend(Spawn).spawner do |user|
  user.first_name   ||= Faker::Name.first_name
  user.last_name    ||= Faker::Name.last_name
  user.email        ||= Faker::Internet.email
  user.access_token ||= SecureRandom.uuid
end
