require 'test/unit'
require File.dirname(__FILE__) + '/../lib/keyword_search'
  
class TestKeywordSearch < Test::Unit::TestCase
  
  NAME_AND_AGE = %<bruce williams age:26>
  NAME_QUOTED_AND_AGE = %<"bruce williams" age:26>
  NAME_AND_QUOTED_AGE = %<bruce williams age:"26">  
  DEFAULT_AGE_WITH_QUOTED_AGE = %<26 name:"bruce williams">
  DEFAULT_AGE_WITH_SINGLE_QUOTED_AGE = %<26 name:'bruce williams'>
  NAME_WITH_NESTED_SINGLE_QUOTES = %<"d'arcy d'uberville" age:28>
  
  def test_default_keyword
    result = nil
    KeywordSearch.search(NAME_AND_AGE) do |with|
      with.default_keyword :name
      with.keyword :name do |values|
        result = values.join(' ')
      end
    end
    assert_equal 'bruce williams', result
  end
  
  def test_unquoted_keyword_term
    result = nil
    KeywordSearch.search(NAME_AND_AGE) do |with|
      with.keyword :age do |values|
        result = Integer(values.first)
      end
    end
    assert_equal 26, result    
  end
  
  def test_quoted_default_keyword_term
    result = nil
    KeywordSearch.search(NAME_QUOTED_AND_AGE) do |with|
      with.default_keyword :name
      with.keyword :name do |values|
        result = values.join(' ')
      end
    end
    assert_equal 'bruce williams', result    
  end
  
  def test_quoted_keyword_term
    result = nil
    KeywordSearch.search(NAME_AND_QUOTED_AGE) do |with|
      with.keyword :age do |values|
        result = Integer(values.first)
      end
    end
    assert_equal 26, result    
  end
  
  def test_quoted_keyword_term_with_whitespace
    result = nil
    KeywordSearch.search(DEFAULT_AGE_WITH_QUOTED_AGE) do |with|
      with.default_keyword :age
      with.keyword :name do |values|
        result = values.first
      end
    end
    assert_equal 'bruce williams', result    
  end
  
  def test_single_quoted_keyword_term_with_whitespace
    result = nil
    KeywordSearch.search(DEFAULT_AGE_WITH_SINGLE_QUOTED_AGE) do |with|
      with.default_keyword :age
      with.keyword :name do |values|
        result = values.first
      end
    end
    assert_equal 'bruce williams', result    
  end
  
  def test_nested_single_quote_is_accumulated
    result = nil
    KeywordSearch.search(NAME_WITH_NESTED_SINGLE_QUOTES) do |with|
      with.default_keyword :name
      with.keyword :name do |values|
        result = values.first
      end
    end
    assert_equal %<d'arcy d'uberville>, result    
  end
  
  def test_nested_double_quote_is_accumulated
    result = nil
    KeywordSearch.search(%<'he was called "jake"'>) do |with|
      with.default_keyword :text
      with.keyword :text do |values|
        result = values.first
      end
    end
    assert_equal %<he was called "jake">, result    
  end
  
  def test_bare_single_quote_in_unquoted_literal_is_accumulated
    result = nil
    KeywordSearch.search(%<bruce's age:27>) do |with|
      with.default_keyword :text
      with.keyword :text do |values|
        result = values.first
      end
    end
    assert_equal %<bruce's>, result    
  end
  
  def test_single_quoted_literal_is_accumulated
    result = nil
    KeywordSearch.search(%<foo 'bruce williams' age:27>) do |with|
      with.default_keyword :text
      with.keyword :text do |values|
        result = values.last
      end
    end
    assert_equal %<bruce williams>, result    
  end
  
  def test_period_in_literal_is_accumulated
    result = nil
    KeywordSearch.search(%<okay... age:27>) do |with|
      with.default_keyword :text
      with.keyword :text do |values|
        result = values.first
      end
    end
    assert_equal %<okay...>, result    
  end
  
  def test_parse_error_results_in_exception
    assert_raises(KeywordSearch::ParseError) do
      KeywordSearch.search(%<we_do_not_allow:! or ::>) do |with|
        with.default_keyword :text
        with.keyword :text do |values|
          result = values.first
        end
      end
    end
  end
  
end






