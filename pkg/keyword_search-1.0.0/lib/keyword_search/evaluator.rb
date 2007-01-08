module KeywordSearch
  
  class Evaluator < Dhaka::Evaluator

    self.grammar = Grammar

    define_evaluation_rules do

      for_multiple_pairs do
        child_nodes[1].each do |key, terms|
          child_nodes[0][key] ||= []
          child_nodes[0][key] += terms
        end
        child_nodes[0]
      end

      for_one_pair do
        child_nodes[0]
      end

      for_keyword_and_term do
        {child_nodes[0].token.value => [child_nodes[1].token.value]}
      end

      for_default_keyword_term do
        {:default => [child_nodes[0].token.value]}
      end

    end

  end
  
end