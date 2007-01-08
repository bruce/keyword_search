module KeywordSearch
  
  class Grammar < Dhaka::Grammar
  
    for_symbol(Dhaka::START_SYMBOL_NAME) do
      start ['Pairs']
    end
  
    for_symbol 'Pairs' do
      one_pair ['Pair']
      multiple_pairs ['Pairs', 'Pair']
    end
  
    for_symbol 'Pair' do
      keyword_and_term ['k', 's']
      default_keyword_term ['s']
    end
    
  end
  
end