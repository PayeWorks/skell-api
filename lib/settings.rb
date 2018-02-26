File.read("env.#{ENV['RACK_ENV']}.sh").scan(/^([^#].*?)="?([^"]*)"?$/).each do |key, value|
  ENV[key] ||= value.to_s.strip
  Cuba.settings[key] = ENV[key]
end

%w(SESSION_SECRET DB_URI).each do |key|
  raise "Configure #{key} in env.#{ENV['RACK_ENV']}.sh" unless Cuba.settings[key]
end
