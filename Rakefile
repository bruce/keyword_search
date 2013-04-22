require "bundler/gem_tasks"
require 'rake/testtask'

desc "Run tests"
Rake::TestTask.new("test") { |t|
  t.pattern = 'test/test_*.rb'
  t.verbose = true
  t.warning = true
}
