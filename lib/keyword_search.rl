require File.dirname(__FILE__) << '/keyword_search/definition.rb'

module KeywordSearch

  class ParseError < ::SyntaxError; end  
      
  class << self
  
    %%{
      
      machine parser;
      
      action start {
        tokstart = p;
      }
      
      action key {
        key = data[tokstart...p-1]
        results[key] ||= []
      }
      
      action default {
        key = nil
      }
      
      action value {
        value = data[tokstart..p-1]
        if ["("].include?(value[0,1])
          value = parse(value[1..-2])[:default]
        elsif ["'", '"'].include?(value[0,1])
          value = value[1..-2]
        end
        (results[key || :default] ||= []) << value
      }
      
      action quote { quotes += 1 }
      
      action unquote { quotes -= 1 }
      
      bareword = [^ '"(:] [^ "):]*; # allow apostrophes
      grouped = '(' @ quote any* :>> ')' @ unquote;
      dquoted = '"' @ quote any* :>> '"' @ unquote;
      squoted = '\'' @ quote any* :>> '\'' @ unquote;
      
      
      value = ( grouped | dquoted | squoted | bareword );
      
      pair = (bareword > start ':') % key value > start % value ;
      
      definition = ( pair | value > start > default % value) ' ';        
      main := definition** 0
              @!{ raise ParseError, "At offset #{p}, near: '#{data[p,10]}'" };        
    	    
    }%%
    
    def search(input_string, definition=nil, &block)
      definition ||= Definition.new(&block)
      results = parse(input_string)
      results.each do |key, terms|
        definition.handle(key, terms)
      end
      results
    end
    
    #######
    private
    #######
    
    def parse(input) #:nodoc:
      data = input + ' '
      %% write data;
    	p = 0
      eof = nil
    	pe = data.length
    	key = nil
    	tokstart = nil
    	results = {}
    	quotes = 0
      %% write init;
      %% write exec;
    	unless quotes.zero?
    	  raise ParseError, "Unclosed quotes"
    	end
    	results
    end
    
  end
  
end


