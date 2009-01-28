module KeywordSearch
  
  class Definition
    
    class Keyword
      
      attr_reader :name, :description, :handler
      def initialize(name, description=nil, &handler)
        @name, @description = name, description
        @handler = handler
      end
      
      def handle(value)
        handler.call(value)
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
      
    def handle(key, values, sign = nil)
      key = @default_keyword if key == :default
      return false unless key
      if k = keywords.detect { |kw| kw.name == key.to_sym}
        k.handle(values)
      end
    end
    
  end
  
end