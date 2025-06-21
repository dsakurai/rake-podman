require 'rake/clean'
require 'io/console'

# Define the default task
task default: :info

task :hello_podman do
    sh "podman-remote run --rm hello-world"
end

# Define a task
task :info do
    puts "HOST_WORKDIR=#{ENV['HOST_WORKDIR']}"
end