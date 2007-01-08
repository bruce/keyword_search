# -*- ruby -*-

require 'rubygems'
require 'hoe'
require './lib/keyword_search.rb'

Hoe.new('keyword_search', KeywordSearch::VERSION) do |p|
  p.rubyforge_name = 'codefluency'
  p.summary = 'Generic support for extracting GMail-style search keywords/values from strings'
  p.description = p.paragraphs_of('README.txt', 2..5).join("\n\n")
  p.url = p.paragraphs_of('README.txt', 0).first.split(/\n/)[1..-1]
  p.author = 'Bruce Williams'
  p.email = 'bruce@codefluency.com'
  p.changes = p.paragraphs_of('History.txt', 0..1).join("\n\n")
end

task :rebuild_parser do
  require 'dhaka'
  parser = Dhaka::Parser.new(KeywordSearch::Grammar)
  File.open('lib/keyword_search/parser.rb', 'w') do |file|
    file << parser.compile_to_ruby_source_as('KeywordSearch::Parser')
  end
end

# vim: syntax=Ruby
