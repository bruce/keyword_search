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
  p.extra_deps = [['dhaka', '= 2.1.0']]
end

task :rebuild_parser do
  require 'dhaka'
  parser = Dhaka::Parser.new(KeywordSearch::Grammar)
  File.open('lib/keyword_search/parser.rb', 'w') do |file|
    file << parser.compile_to_ruby_source_as('KeywordSearch::Parser')
  end
end

task :rebuild_lexer do
  require 'dhaka'
  lexer = Dhaka::Lexer.new(KeywordSearch::LexerSpec)
  File.open('lib/keyword_search/lexer.rb', 'w') do |file|
    file << lexer.compile_to_ruby_source_as('KeywordSearch::Lexer')
  end
end

task :rebuild_lexer do
  require 'dhaka'
  lexer = Dhaka::Lexer.new(KeywordSearch::LexerSpec)
  File.open('lib/keyword_search/lexer.rb', 'w') do |file|
    file << lexer.compile_to_ruby_source_as('KeywordSearch::Lexer')
  end
end

# vim: syntax=Ruby
