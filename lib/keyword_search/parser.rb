class KeywordSearch::Parser < Dhaka::CompiledParser

  self.grammar = KeywordSearch::Grammar

  start_with 0

  at_state(1) {
    for_symbols("_End_") { reduce_with "start" }
    for_symbols("s") { shift_to 3 }
    for_symbols("Pair") { shift_to 2 }
  }

  at_state(5) {
    for_symbols("_End_", "s") { reduce_with "keyword_and_term" }
  }

  at_state(4) {
    for_symbols("s") { shift_to 5 }
  }

  at_state(2) {
    for_symbols("_End_", "s") { reduce_with "multiple_pairs" }
  }

  at_state(0) {
    for_symbols("Pair") { shift_to 6 }
    for_symbols("s") { shift_to 3 }
    for_symbols("Pairs") { shift_to 1 }
  }

  at_state(6) {
    for_symbols("_End_", "s") { reduce_with "one_pair" }
  }

  at_state(3) {
    for_symbols(":") { shift_to 4 }
    for_symbols("_End_", "s") { reduce_with "default_keyword_term" }
  }

end