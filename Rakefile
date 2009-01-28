# -*- ruby -*-

require 'rubygems'
require 'echoe'

Echoe.new 'keyword_search' do |p|
  p.version = '1.3.1'
  p.author = "Bruce Williams"
  p.email  = 'bruce@codefluency.com'
  p.project = 'codefluency'
  p.summary = "Generic library to parse GMail-style search strings for keyword/value pairs; supports definition of valid keywords and handling of quoted values."
  p.url = "http://github.com/bruce/keyword_search"
  p.include_rakefile = true
end

rule '.rb' => '.rl' do |t|
  sh "ragel -R #{t.source}"
end

task :ragel => 'lib/keyword_search.rb'
