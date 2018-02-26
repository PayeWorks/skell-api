require 'mina/git'
require 'mina/rbenv'

set :shared_paths, [
  'pid',
  'log',
  'tmp',
  'env.production.sh',
  'pdfs',
  'purchases',
  'newrelic.yml'
]

set :domain, 'staging.paye_sam.com'
set :deploy_to, '/home/ubuntu/apps/api'
set :base_path, '/home/ubuntu/apps'
set :repository, 'git@gitlab.com:paye_sam/api.git'
set :branch, ENV["BRANCH"] || 'master'
set :user, 'ubuntu'

# Required mina_slack options


task :environment do
  invoke :'rbenv:load'
end

task setup: :environment do
  queue! %(mkdir -p "#{deploy_to}/shared/log")
  queue! %(chmod g+rx,u+rwx "#{deploy_to}/shared/log")

  queue! %(mkdir -p "#{deploy_to}/shared/config")
  queue! %(chmod g+rx,u+rwx "#{deploy_to}/shared/config")

  queue! %(mkdir -p "#{deploy_to}/shared/pid")
  queue! %(chmod g+rx,u+rwx "#{deploy_to}/shared/pid")

  queue! %(mkdir -p "#{deploy_to}/shared/tmp")
  queue! %(chmod g+rx,u+rwx "#{deploy_to}/shared/tmp")

  queue! %(gem install dep)
end

desc 'Deploys the current version to the server.'

task :deploy_frontend do
  queue "cd #{base_path}/ && supervisorctl "\
        "-c #{base_path}/supervisord.conf status"
  queue "cd #{base_path}/ && supervisorctl "\
        "-c #{base_path}/supervisord.conf stop unicorn:unicorn-00"
  if branch.to_s != 'master'
    queue "cd #{base_path}/frontend && git checkout master"\
          "&& git fetch origin #{branch}:#{branch} "\
          "&& git checkout #{branch}  && npm i && bower install && gulp"
  else
    queue "cd #{base_path}/frontend && git checkout master"\
          "&& git pull --rebase origin master && npm i && bower install && gulp"
  end
  queue "cd #{base_path}/ && supervisorctl "\
        "-c #{base_path}/supervisord.conf start unicorn:unicorn-00"
  queue "cd #{base_path}/ && supervisorctl "\
        "-c #{base_path}/supervisord.conf status"
end

task :dep_install do
  queue 'dep install -f .gems'
end

task :run_migrations do
  queue 'rake db:migrate'
end

task deploy: :environment do
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :dep_install
    invoke :run_migrations

    to :launch do
      queue "supervisorctl -c #{base_path}/supervisord.conf status"
      queue "supervisorctl -c #{base_path}/supervisord.conf restart all"
      queue "supervisorctl -c #{base_path}/supervisord.conf status"
    end
  end
end
