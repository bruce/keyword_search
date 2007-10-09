# -*- ruby -*-

require 'rubygems'
require 'hoe'

Hoe.new('keyword_search', '1.3.1') do |p|
  p.rubyforge_name = 'codefluency'
  p.summary = 'Generic support for extracting GMail-style search keywords/values from strings'
  p.description = p.paragraphs_of('README.txt', 2..5).join("\n\n")
  p.url = p.paragraphs_of('README.txt', 0).first.split(/\n/)[1..-1]
  p.author = 'Bruce Williams'
  p.email = 'bruce@codefluency.com'
  p.changes = p.paragraphs_of('History.txt', 0..1).join("\n\n")
end

rule '.rb' => '.rl' do |t|
  sh "ragel -R #{t.source} | rlgen-ruby -o #{t.name}"
end

task :ragel => 'lib/keyword_search.rb'