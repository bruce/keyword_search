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
        key = word
        results[key] ||= []
      }
      
      action default {
        key = nil
      }
      
      action word {
        word = data[tokstart..p-1]
      }
      
      action value {
        (results[key || :default] ||= []) << [ word, positive_match ]
      }
      
      action negative_match {
        positive_match = false
      }
      
      action positive_match {
        positive_match = true
      }
      
      action quote { quotes += 1 }
      
      action unquote { quotes -= 1 }

      seperators = ' '+ | / *[,|] */ ;

      bareword = ( [^ '"(:] . [^ "):]* ) > start % word ; # allow apostrophes
      dquoted = '"' @ quote ( [^"]* > start % word ) :>> '"' @ unquote;
      squoted = '\'' @ quote ( [^']* > start % word ) :>> '\'' @ unquote;

      anyword = dquoted | squoted | bareword ;      

      anyvalue = anyword % value ;
      multivalues = anyvalue ( seperators anyvalue )* ;
      groupedvalues = '(' @ quote multivalues :>> ')' @ unquote;

      value = groupedvalues | anyvalue ;

      pair = bareword % key ':' value ;

      value_only = value > default ;
      
      match_mode = ('-' % negative_match | '+'? % positive_match ) ;

      definition = match_mode? <: ( pair | value_only ) ;
      
      definitions = definition ( ' '+ definition )*;

      main := ' '* definitions? ' '* 0
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
      word = nil
    	pe = data.length
    	key = nil
      positive_match = nil
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


