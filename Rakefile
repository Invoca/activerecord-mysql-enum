# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

task default: :rspec

desc "run rspec unit tests"
begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:rspec) do |rspec_task|
    # rspec_task.exclude_pattern = 'spec/e2e/**/*_spec.rb'
  end
end
