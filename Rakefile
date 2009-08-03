# -*- ruby -*-

begin
  require 'rubygems'
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name              = "keyword_search"
    gemspec.summary           = "Generic library to parse GMail-style search strings for keyword/value pairs; supports definition of valid keywords and handling of quoted values."
    gemspec.homepage          = "http://github.com/bruce/keyword_search"
    gemspec.email             = [ 'bruce@codefluency.com', 'eric@sevenscale.com' ]
    gemspec.authors           = [ "Bruce Williams", "Eric Lindvall" ]
    gemspec.rubyforge_project = 'codefluency'
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

rule '.rb' => '.rl' do |t|
  sh "ragel -R #{t.source}"
end

task :ragel => 'lib/keyword_search.rb'
