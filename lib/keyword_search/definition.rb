module KeywordSearch
  
  class Definition
    
    class Keyword
      
      attr_reader :name, :description, :handler
      def initialize(name, description=nil, &handler)
        @name, @description = name, description
        @handler = handler
      end
      
      def handle(value, sign)
        # If the handler is only expecting one argument, 
        # only give them the positive matches
        if handler.arity == 1
          handler.call(value) if sign
        else
          handler.call(value, sign)
        end
      end
      
    end

    def initialize
      @default_keyword = nil
      yield self if block_given?
    end
    
    def keywords
      @keywords ||= []
    end

    def keyword(name, description=nil, &block)
      keywords << Keyword.new(name, description, &block)
    end
      
    def default_keyword(name)
      @default_keyword = name
    end
      
    def handle(key, values)
      key = @default_keyword if key == :default
      return false unless key
      true_values, false_values = *values.partition { |v| v[1] }
      
      # Get just the values
      true_values.collect! { |v| v[0] }
      false_values.collect! { |v| v[0] }
      
      if k = keywords.detect { |kw| kw.name == key.to_sym}
        k.handle(true_values, true)
        k.handle(false_values, false) if false_values.length > 0
      end
    end
    
  end
  
end