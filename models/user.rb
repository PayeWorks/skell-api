require 'securerandom'

# :nodoc:
class User < Sequel::Model
  include Shield::Model

  def before_create
    self.access_token ||= SecureRandom.hex
  end

  def self.fetch(identifier)
    filter(email: identifier).first
  end
end
