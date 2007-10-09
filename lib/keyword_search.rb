# line 1 "lib/keyword_search.rl"
require File.dirname(__FILE__) << '/keyword_search/definition.rb'

module KeywordSearch

  class ParseError < ::SyntaxError; end  
      
  class << self
  
    # line 44 "lib/keyword_search.rl"
    
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
      
# line 30 "lib/keyword_search.rb"
class << self
	attr_accessor :_parser_actions
	private :_parser_actions, :_parser_actions=
end
self._parser_actions = [
	0, 1, 3, 1, 4, 2, 0, 2, 
	2, 1, 0
]

class << self
	attr_accessor :_parser_key_offsets
	private :_parser_key_offsets, :_parser_key_offsets=
end
self._parser_key_offsets = [
	0, 0, 5, 8, 12, 15, 16, 17, 
	18
]

class << self
	attr_accessor :_parser_trans_keys
	private :_parser_trans_keys, :_parser_trans_keys=
end
self._parser_trans_keys = [
	0, 32, 34, 39, 58, 32, 34, 58, 
	32, 34, 39, 58, 32, 34, 58, 34, 
	32, 39, 32, 34, 58, 0
]

class << self
	attr_accessor :_parser_single_lengths
	private :_parser_single_lengths, :_parser_single_lengths=
end
self._parser_single_lengths = [
	0, 5, 3, 4, 3, 1, 1, 1, 
	3
]

class << self
	attr_accessor :_parser_range_lengths
	private :_parser_range_lengths, :_parser_range_lengths=
end
self._parser_range_lengths = [
	0, 0, 0, 0, 0, 0, 0, 0, 
	0
]

class << self
	attr_accessor :_parser_index_offsets
	private :_parser_index_offsets, :_parser_index_offsets=
end
self._parser_index_offsets = [
	0, 0, 6, 10, 15, 19, 21, 23, 
	25
]

class << self
	attr_accessor :_parser_trans_targs_wi
	private :_parser_trans_targs_wi, :_parser_trans_targs_wi=
end
self._parser_trans_targs_wi = [
	8, 0, 5, 7, 0, 2, 1, 0, 
	3, 2, 0, 5, 7, 0, 4, 1, 
	0, 0, 4, 6, 5, 1, 0, 6, 
	7, 1, 0, 3, 2, 0
]

class << self
	attr_accessor :_parser_trans_actions_wi
	private :_parser_trans_actions_wi, :_parser_trans_actions_wi=
end
self._parser_trans_actions_wi = [
	5, 3, 5, 5, 3, 5, 1, 0, 
	0, 0, 0, 8, 8, 0, 8, 1, 
	0, 0, 0, 0, 0, 1, 0, 0, 
	0, 1, 0, 0, 0, 0
]

class << self
	attr_accessor :parser_start
end
self.parser_start = 1;
class << self
	attr_accessor :parser_first_final
end
self.parser_first_final = 8;
class << self
	attr_accessor :parser_error
end
self.parser_error = 0;

class << self
	attr_accessor :parser_en_main
end
self.parser_en_main = 1;

# line 62 "lib/keyword_search.rl"
    	p = 0
    	pe = data.length
    	key = nil
    	tokstart = nil
    	results = {}
      
# line 133 "lib/keyword_search.rb"
begin
	p ||= 0
	pe ||= data.length
	cs = parser_start
end
# line 68 "lib/keyword_search.rl"
      
# line 141 "lib/keyword_search.rb"
begin
	_klen, _trans, _keys, _acts, _nacts = nil
	if p != pe
	if cs != 0
	while true
	_break_resume = false
	begin
	_break_again = false
	_keys = _parser_key_offsets[cs]
	_trans = _parser_index_offsets[cs]
	_klen = _parser_single_lengths[cs]
	_break_match = false
	
	begin
	  if _klen > 0
	     _lower = _keys
	     _upper = _keys + _klen - 1

	     loop do
	        break if _upper < _lower
	        _mid = _lower + ( (_upper - _lower) >> 1 )

	        if data[p] < _parser_trans_keys[_mid]
	           _upper = _mid - 1
	        elsif data[p] > _parser_trans_keys[_mid]
	           _lower = _mid + 1
	        else
	           _trans += (_mid - _keys)
	           _break_match = true
	           break
	        end
	     end # loop
	     break if _break_match
	     _keys += _klen
	     _trans += _klen
	  end
	  _klen = _parser_range_lengths[cs]
	  if _klen > 0
	     _lower = _keys
	     _upper = _keys + (_klen << 1) - 2
	     loop do
	        break if _upper < _lower
	        _mid = _lower + (((_upper-_lower) >> 1) & ~1)
	        if data[p] < _parser_trans_keys[_mid]
	          _upper = _mid - 2
	        elsif data[p] > _parser_trans_keys[_mid+1]
	          _lower = _mid + 2
	        else
	          _trans += ((_mid - _keys) >> 1)
	          _break_match = true
	          break
	        end
	     end # loop
	     break if _break_match
	     _trans += _klen
	  end
	end while false
	cs = _parser_trans_targs_wi[_trans]
	break if _parser_trans_actions_wi[_trans] == 0
	_acts = _parser_trans_actions_wi[_trans]
	_nacts = _parser_actions[_acts]
	_acts += 1
	while _nacts > 0
		_nacts -= 1
		_acts += 1
		case _parser_actions[_acts - 1]
when 0:
# line 13 "lib/keyword_search.rl"
		begin

        tokstart = p;
      		end
# line 13 "lib/keyword_search.rl"
when 1:
# line 17 "lib/keyword_search.rl"
		begin

        key = data[tokstart...p-1]
        results[key] ||= []
      		end
# line 17 "lib/keyword_search.rl"
when 2:
# line 22 "lib/keyword_search.rl"
		begin

        key = nil
      		end
# line 22 "lib/keyword_search.rl"
when 3:
# line 26 "lib/keyword_search.rl"
		begin

        value = data[tokstart..p-1]
        value = value[1..-2] if ["'", '"'].include?(value[0,1])
        (results[key || :default] ||= []) << value
      		end
# line 26 "lib/keyword_search.rl"
when 4:
# line 42 "lib/keyword_search.rl"
		begin
 raise ParseError, "At offset #{p}, near: '#{data[p,10]}'" 		end
# line 42 "lib/keyword_search.rl"
# line 244 "lib/keyword_search.rb"
		end # action switch
	end
	end while false
	break if _break_resume
	break if cs == 0
	p += 1
	break if p == pe
	end
	end
	end
	end
# line 69 "lib/keyword_search.rl"
    	
# line 258 "lib/keyword_search.rb"
# line 70 "lib/keyword_search.rl"
    	results
    end
    
  end
  
end


