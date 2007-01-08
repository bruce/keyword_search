module KeywordSearch
  
  class Tokenizer < Dhaka::Tokenizer

    letters = ('a'..'z').to_a
    numbers = ('0'..'9').to_a
    extras = %w|_ - '|
    printables = letters + numbers + extras
    whitespace = [' ']
    quotes = ['"']
    keyword_separator = [':']
    all_characters = keyword_separator + printables + whitespace

    for_state :idle_state do
    
      for_characters(printables) do
        self.accumulator = ''
        switch_to :unquoted_literal_state
      end

      for_characters quotes do
        self.accumulator = ''
        advance
        switch_to :quoted_literal_state
      end
    
      for_characters whitespace do
        advance
      end
    
    end
  
    for_state :unquoted_literal_state do
    
      for_characters(printables) do
        self.accumulator += curr_char
        advance
        tokens << Dhaka::Token.new(Grammar.symbol_for_name('s'), accumulator) unless curr_char
      end
    
      for_characters(keyword_separator) do
        tokens << Dhaka::Token.new(Grammar.symbol_for_name('k'), self.accumulator)
        advance
        switch_to :idle_state
      end
    
      for_characters(whitespace) do
        tokens << Dhaka::Token.new(Grammar.symbol_for_name('s'), self.accumulator)
        switch_to :idle_state
      end
    
    end
  
    for_state :quoted_literal_state do
      for_characters(all_characters - quotes) do
        self.accumulator += curr_char
        advance
      end
      for_characters quotes do
        tokens << Dhaka::Token.new(Grammar.symbol_for_name('s'), self.accumulator)
        advance
        switch_to :idle_state
      end
    end

  end

end
