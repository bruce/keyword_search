require 'dhaka'

dirname = File.join(File.dirname(__FILE__), 'keyword_search')
%w|grammar tokenizer parser evaluator definition|.each do |dependency|
  require File.join(dirname, dependency)
end

module KeywordSearch
  
  VERSION = '1.0.4'
  
  class << self
    def search(input_string, definition=nil, &block)
      definition ||= Definition.new(&block)
      tokens = Tokenizer.tokenize(input_string.downcase)
      parse_result = Parser.parse(tokens)
      unless parse_result.has_error?
        Evaluator.new(parse_result.syntax_tree).result.each do |key, terms|
          definition.handle(key, terms)
        end
      end
    end
  end
  
end