module KeywordSearch
  
  class Tokenizer < Dhaka::Tokenizer


    # TODO: Add further character support; this is just for initial release
    letters = ('a'..'z').to_a
    numbers = ('0'..'9').to_a
    extras = %w|_ - ' / \ [ ] { } 1 @ # $ % ^ & * ( ) . , ? < > |
    printables = letters + numbers + extras
    whitespace = [' ']
    quotes = %w|' "|
    keyword_separator = [':']
    all_characters = keyword_separator + printables + whitespace + quotes

    for_state :idle_state do
    
      for_characters(printables) do
        self.accumulator = ''
        switch_to :unquoted_literal_state
      end

      for_characters(quotes) do
       advance if self.accumulator && !self.accumulator.empty?
       self.accumulator = ''
        case curr_char
        when %<">
          advance
          switch_to :double_quoted_literal_state
        when %<'>
          advance
          switch_to :single_quoted_literal_state
        end
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
        self.accumulator = ''
        advance
        switch_to :idle_state
      end
    
      for_characters(whitespace) do
        tokens << Dhaka::Token.new(Grammar.symbol_for_name('s'), self.accumulator)
        self.accumulator = ''
        switch_to :idle_state
      end
    
    end
  
    for_state :double_quoted_literal_state do
      for_characters(all_characters - %w<">) do
        self.accumulator += curr_char
        advance
      end
      for_characters %w<"> do
        tokens << Dhaka::Token.new(Grammar.symbol_for_name('s'), self.accumulator)
        self.accumulator = ''
        advance
        switch_to :idle_state
      end
    end

    for_state :single_quoted_literal_state do
      for_characters(all_characters - %w<'>) do
        self.accumulator += curr_char
        advance
      end
      for_characters %w<'> do
        tokens << Dhaka::Token.new(Grammar.symbol_for_name('s'), self.accumulator)
        self.accumulator = ''
        advance
        switch_to :idle_state
      end
    end

  end

end
