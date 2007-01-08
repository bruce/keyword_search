class KeywordSearch::Parser < Dhaka::CompiledParser

  self.grammar = KeywordSearch::Grammar

  start_with 0

  at_state(3) {
    for_symbol('k') { reduce_with 'default_keyword_term' }
    for_symbol('_End_') { reduce_with 'default_keyword_term' }
    for_symbol('s') { reduce_with 'default_keyword_term' }
  }

  at_state(0) {
    for_symbol('k') { shift_to 4 }
    for_symbol('Pairs') { shift_to 1 }
    for_symbol('s') { shift_to 3 }
    for_symbol('Pair') { shift_to 6 }
  }

  at_state(4) {
    for_symbol('s') { shift_to 5 }
  }

  at_state(5) {
    for_symbol('k') { reduce_with 'keyword_and_term' }
    for_symbol('_End_') { reduce_with 'keyword_and_term' }
    for_symbol('s') { reduce_with 'keyword_and_term' }
  }

  at_state(1) {
    for_symbol('k') { shift_to 4 }
    for_symbol('_End_') { reduce_with 'start' }
    for_symbol('s') { shift_to 3 }
    for_symbol('Pair') { shift_to 2 }
  }

  at_state(6) {
    for_symbol('k') { reduce_with 'one_pair' }
    for_symbol('_End_') { reduce_with 'one_pair' }
    for_symbol('s') { reduce_with 'one_pair' }
  }

  at_state(2) {
    for_symbol('k') { reduce_with 'multiple_pairs' }
    for_symbol('_End_') { reduce_with 'multiple_pairs' }
    for_symbol('s') { reduce_with 'multiple_pairs' }
  }

end