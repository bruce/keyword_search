require 'dhaka'

dirname = File.join(File.dirname(__FILE__), 'keyword_search')
%w|grammar parser tokenizer evaluator definition|.each do |dependency|
  require File.join(dirname, dependency)
end

module KeywordSearch
  
  class ParseError < ::SyntaxError; end
  
  VERSION = '1.2.1'
  
  class << self
    def search(input_string, definition=nil, &block)
      @evaluator ||= Evaluator.new
      definition ||= Definition.new(&block)
      parse_result = Parser.parse(Tokenizer.tokenize(input_string))
      unless parse_result.has_error?
        results = @evaluator.evaluate(parse_result.parse_tree)
        results.each do |key, terms|
          definition.handle(key, terms)
        end
        results
      else
        raise ParseError, "Unexpected token #{parse_result.unexpected_token.inspect}"
      end
    end
  end
  
end