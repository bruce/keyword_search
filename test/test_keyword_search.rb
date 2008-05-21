require 'test/unit'

require 'rubygems' rescue nil
require 'test/spec'

require File.dirname(__FILE__) + '/../lib/keyword_search'
  
context "KeywordSearch" do
  
  NAME_AND_AGE = %<bruce williams age:26>
  NAME_QUOTED_AND_AGE = %<"bruce williams" age:26>
  NAME_AND_QUOTED_AGE = %<bruce williams age:"26">  
  DEFAULT_AGE_WITH_QUOTED_AGE = %<26 name:"bruce williams">
  DEFAULT_AGE_WITH_SINGLE_QUOTED_AGE = %<26 name:'bruce williams'>
  NAME_WITH_NESTED_SINGLE_QUOTES = %<"d'arcy d'uberville" age:28>
  NAME_AND_GROUPED_AGE = %<coda hale age:(27)>
  NAME_AND_GROUPED_QUOTED_AGE = %<coda hale age:("27")>
  NAME_AND_GROUPED_QUOTED_AGES = %<coda hale age:("27" 34 '48')>
  GROUPED_NAMES_AND_AGE = %<(coda bruce 'hale' "williams") age:20>
  
  specify "default keyword" do
    result = nil
    KeywordSearch.search(NAME_AND_AGE) do |with|
      with.default_keyword :name
      with.keyword :name do |values|
        result = values.join(' ')
      end
    end
    assert_equal 'bruce williams', result
  end
  
  specify "grouped default keywords" do
    result = nil
    KeywordSearch.search(GROUPED_NAMES_AND_AGE) do |with|
      with.default_keyword :name
      with.keyword :name do |values|
        result = values.first
      end
    end
    assert_equal ['coda', 'bruce', 'hale', 'williams'], result
  end
  
  specify "unquoted keyword term" do
    result = nil
    KeywordSearch.search(NAME_AND_AGE) do |with|
      with.keyword :age do |values|
        result = Integer(values.first)
      end
    end
    assert_equal 26, result    
  end
  
  specify "unquoted grouped keyword term" do
    result = nil
    KeywordSearch.search(NAME_AND_GROUPED_AGE) do |with|
      with.keyword :age do |values|
        result = Integer(values.first.first)
      end
    end
    assert_equal 27, result    
  end
  
  specify "quoted grouped keyword term" do
    result = nil
    KeywordSearch.search(NAME_AND_GROUPED_QUOTED_AGE) do |with|
      with.keyword :age do |values|
        result = Integer(values.first.first)
      end
    end
    assert_equal 27, result    
  end
  
  specify "mixed grouped keyword terms" do
    result = nil
    KeywordSearch.search(NAME_AND_GROUPED_QUOTED_AGES) do |with|
      with.keyword :age do |values|
        result = values.first.map { |v| v.to_i }
      end
    end
    assert_equal [27, 34, 48], result
  end
  
  specify "quoted default keyword term" do
    result = nil
    KeywordSearch.search(NAME_QUOTED_AND_AGE) do |with|
      with.default_keyword :name
      with.keyword :name do |values|
        result = values.join(' ')
      end
    end
    assert_equal 'bruce williams', result    
  end
  
  specify "quoted keyword term" do
    result = nil
    KeywordSearch.search(NAME_AND_QUOTED_AGE) do |with|
      with.keyword :age do |values|
        result = Integer(values.first)
      end
    end
    assert_equal 26, result    
  end
  
  specify "quoted keyword term with whitespace" do
    result = nil
    KeywordSearch.search(DEFAULT_AGE_WITH_QUOTED_AGE) do |with|
      with.default_keyword :age
      with.keyword :name do |values|
        result = values.first
      end
    end
    assert_equal 'bruce williams', result    
  end
  
  specify "single quoted keyword term with whitespace" do
    result = nil    
    r = KeywordSearch.search(DEFAULT_AGE_WITH_SINGLE_QUOTED_AGE) do |with|
      with.default_keyword :age
      with.keyword :name do |values|
        result = values.first
      end
    end
    assert_equal 'bruce williams', result    
  end
  
  specify "nested single quote is accumulated" do
    result = nil
    KeywordSearch.search(NAME_WITH_NESTED_SINGLE_QUOTES) do |with|
      with.default_keyword :name
      with.keyword :name do |values|
        result = values.first
      end
    end
    assert_equal %<d'arcy d'uberville>, result    
  end
  
  specify "nested double quote is accumulated" do
    result = nil
    KeywordSearch.search(%<'he was called "jake"'>) do |with|
      with.default_keyword :text
      with.keyword :text do |values|
        result = values.first
      end
    end
    assert_equal %<he was called "jake">, result    
  end
  
  specify "bare single quote in unquoted literal is accumulated" do
    result = nil
    KeywordSearch.search(%<bruce's age:27>) do |with|
      with.default_keyword :text
      with.keyword :text do |values|
        result = values.first
      end
    end
    assert_equal %<bruce's>, result    
  end
  
  specify "single quoted literal is accumulated" do
    result = nil
    KeywordSearch.search(%<foo 'bruce williams' age:27>) do |with|
      with.default_keyword :text
      with.keyword :text do |values|
        result = values.last
      end
    end
    assert_equal %<bruce williams>, result    
  end
  
  specify "period in literal is accumulated" do
    result = nil
    KeywordSearch.search(%<okay... age:27>) do |with|
      with.default_keyword :text
      with.keyword :text do |values|
        result = values.first
      end
    end
    assert_equal %<okay...>, result    
  end
  
  specify "parse error results in exception" do
    assert_raises(KeywordSearch::ParseError) do
      KeywordSearch.search(%<we_do_not_allow:! or ::>) do |with|
        with.default_keyword :text
        with.keyword :text do |values|
          result = values.first
        end
      end
    end
  end
  
  specify "can use apostrophes in unquoted literal" do
    result = nil
    KeywordSearch.search(%<d'correct>) do |with|
      with.default_keyword :text
      with.keyword :text do |values|
        result = values.first
      end
    end
    assert_equal "d'correct", result
  end
  
  specify "can use apostrophes in unquoted literal values" do
    result = nil
    KeywordSearch.search(%<text:d'correct>) do |with|
      with.default_keyword :text
      with.keyword :text do |values|
        result = values.first
      end
    end
    assert_equal "d'correct", result
  end
  
  specify "cannot use an apostrophe at the beginning on an unquoted literal" do
    assert_raises(KeywordSearch::ParseError) do
      KeywordSearch.search(%<'thisiswrong>) do |with|
        with.default_keyword :text
        with.keyword :text do |values|
          result = values.first
        end
      end
    end
  end
  
  specify "keywords are case sensitive" do
    result = nil
    KeywordSearch.search(%<Text:justtesting>) do |with|
      with.keyword :text do |values|
        result = :small
      end
      with.keyword :Text do |values|
        result = :big
      end      
    end
    assert_equal :big, result
  end
  
  specify "values are case sensitive" do
    result = nil
    KeywordSearch.search(%<text:Big>) do |with|
      with.keyword :text do |values|
        result = values.first
      end
    end
    assert_equal 'Big', result
  end
  
end






