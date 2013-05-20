require "bundler/gem_tasks"
require 'rake/testtask'

desc "Run tests"
Rake::TestTask.new do |t|
  t.pattern = 'test/test_*.rb'
  t.verbose = true
  t.warning = false # Ragel is noisy
end

task default: :test

desc "Build parser with Ragel"
task :ragel do
  sh "ragel -R lib/keyword_search.rl -o lib/keyword_search.rb"
end
