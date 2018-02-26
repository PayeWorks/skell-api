# set path to app that will be used to configure unicorn,
# note the trailing slash in this example
@dir = "/home/ubuntu/apps/api/current/"

worker_processes 4
working_directory @dir

timeout 60

# Specify path to socket unicorn listens to,
# we will use this in our nginx.conf later
listen "#{@dir}tmp/unicorn.sock", :backlog => 64

# Set process id path
pid "#{@dir}pid/unicorn.pid"

# Set log file paths
stderr_path "#{@dir}log/unicorn.stderr.log"
stdout_path "#{@dir}log/unicorn.stdout.log"
