module KeywordSearch
  
  class Evaluator < Dhaka::Evaluator

    self.grammar = Grammar

    define_evaluation_rules do

      for_multiple_pairs do
        child_nodes.inject({}) do |result,child_node|
          evaluate(child_node).each do |key,value|
            result[key] ||= []
            result[key] += value
          end
          result
        end
      end

      for_one_pair do
        evaluate(child_nodes.first)
      end

      for_keyword_and_term do
        {child_nodes.first.tokens.first.value => [child_nodes.last.tokens.first.value]}
      end

      for_default_keyword_term do
        {:default => [child_nodes[0].tokens[0].value]}
      end

    end

  end
  
end