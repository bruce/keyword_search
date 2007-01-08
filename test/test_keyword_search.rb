require 'test/unit'
require 'lib/keyword_search'
  
class TestKeywordSearch < Test::Unit::TestCase
  
  NAME_AND_AGE = %<bruce williams age:26>
  NAME_QUOTED_AND_AGE = %<"bruce williams" age:26>
  NAME_AND_QUOTED_AGE = %<bruce williams age:"26">
  DEFAULT_AGE_WITH_QUOTED_AGE = %<26 name:"bruce williams">
  
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
  
end






