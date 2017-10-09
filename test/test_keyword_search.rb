require 'minitest/spec'
require 'minitest/autorun'

require File.dirname(__FILE__) + '/../lib/keyword_search'

describe "KeywordSearch" do

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

  it "default keyword" do
    result = nil
    KeywordSearch.search(NAME_AND_AGE) do |with|
      with.default_keyword :name
      with.keyword :name do |values|
        result = values.join(' ')
      end
    end
    result.must_equal 'bruce williams'
    assert_equal 'bruce williams', result
  end

  it "grouped default keywords" do
    result = nil
    KeywordSearch.search(GROUPED_NAMES_AND_AGE) do |with|
      with.default_keyword :name
      with.keyword :name do |values|
        result = values
      end
    end
    assert_equal ['coda', 'bruce', 'hale', 'williams'], result
  end

  it "unquoted keyword term" do
    result = nil
    KeywordSearch.search(NAME_AND_AGE) do |with|
      with.keyword :age do |values|
        result = Integer(values.first)
      end
    end
    assert_equal 26, result
  end

  it "unquoted grouped keyword term" do
    result = nil
    KeywordSearch.search(NAME_AND_GROUPED_AGE) do |with|
      with.keyword :age do |values|
        result = Integer(values.first)
      end
    end
    assert_equal 27, result
  end

  it "quoted grouped keyword term" do
    result = nil
    KeywordSearch.search(NAME_AND_GROUPED_QUOTED_AGE) do |with|
      with.keyword :age do |values|
        result = Integer(values.first)
      end
    end
    assert_equal 27, result
  end

  it "mixed grouped keyword terms" do
    result = nil
    KeywordSearch.search(NAME_AND_GROUPED_QUOTED_AGES) do |with|
      with.keyword :age do |values|
        result = values.map { |v| v.to_i }
      end
    end
    assert_equal [27, 34, 48], result
  end

  it "quoted default keyword term" do
    result = nil
    KeywordSearch.search(NAME_QUOTED_AND_AGE) do |with|
      with.default_keyword :name
      with.keyword :name do |values|
        result = values.join(' ')
      end
    end
    assert_equal 'bruce williams', result
  end

  it "quoted keyword term" do
    result = nil
    KeywordSearch.search(NAME_AND_QUOTED_AGE) do |with|
      with.keyword :age do |values|
        result = Integer(values.first)
      end
    end
    assert_equal 26, result
  end

  it "quoted keyword term with whitespace" do
    result = nil
    KeywordSearch.search(DEFAULT_AGE_WITH_QUOTED_AGE) do |with|
      with.default_keyword :age
      with.keyword :name do |values|
        result = values.first
      end
    end
    assert_equal 'bruce williams', result
  end

  it "single quoted keyword term with whitespace" do
    result = nil
    r = KeywordSearch.search(DEFAULT_AGE_WITH_SINGLE_QUOTED_AGE) do |with|
      with.default_keyword :age
      with.keyword :name do |values|
        result = values.first
      end
    end
    assert_equal 'bruce williams', result
  end

  it "nested single quote is accumulated" do
    result = nil
    KeywordSearch.search(NAME_WITH_NESTED_SINGLE_QUOTES) do |with|
      with.default_keyword :name
      with.keyword :name do |values|
        result = values.first
      end
    end
    assert_equal %<d'arcy d'uberville>, result
  end

  it "nested double quote is accumulated" do
    result = nil
    KeywordSearch.search(%<'he was called "jake"'>) do |with|
      with.default_keyword :text
      with.keyword :text do |values|
        result = values.first
      end
    end
    assert_equal %<he was called "jake">, result
  end

  it "bare single quote in unquoted literal is accumulated" do
    result = nil
    KeywordSearch.search(%<bruce's age:27>) do |with|
      with.default_keyword :text
      with.keyword :text do |values|
        result = values.first
      end
    end
    assert_equal %<bruce's>, result
  end

  it "single quoted literal is accumulated" do
    result = nil
    KeywordSearch.search(%<foo 'bruce williams' age:27>) do |with|
      with.default_keyword :text
      with.keyword :text do |values|
        result = values.last
      end
    end
    assert_equal %<bruce williams>, result
  end

  it "period in literal is accumulated" do
    result = nil
    KeywordSearch.search(%<okay... age:27>) do |with|
      with.default_keyword :text
      with.keyword :text do |values|
        result = values.first
      end
    end
    assert_equal %<okay...>, result
  end

  it "parse error results in exception" do
    assert_raises(KeywordSearch::ParseError) do
      KeywordSearch.search(%<we_do_not_allow:! or ::>) do |with|
        with.default_keyword :text
        with.keyword :text do |values|
          result = values.first
        end
      end
    end
  end

  it "can use apostrophes in unquoted literal" do
    result = nil
    KeywordSearch.search(%<d'correct>) do |with|
      with.default_keyword :text
      with.keyword :text do |values|
        result = values.first
      end
    end
    assert_equal "d'correct", result
  end

  it "can use apostrophes in unquoted literal values" do
    result = nil
    KeywordSearch.search(%<text:d'correct>) do |with|
      with.default_keyword :text
      with.keyword :text do |values|
        result = values.first
      end
    end
    assert_equal "d'correct", result
  end

  it "cannot use an apostrophe at the beginning on an unquoted literal" do
    assert_raises(KeywordSearch::ParseError) do
      KeywordSearch.search(%<'thisiswrong>) do |with|
        with.default_keyword :text
        with.keyword :text do |values|
          result = values.first
        end
      end
    end
  end

  it "keywords are case sensitive" do
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

  it "values are case sensitive" do
    result = nil
    KeywordSearch.search(%<text:Big>) do |with|
      with.keyword :text do |values|
        result = values.first
      end
    end
    assert_equal 'Big', result
  end

  it "spaces are condensed" do
    result = nil
    KeywordSearch.search(%<   this   is    some    text   >) do |with|
      with.default_keyword :text
      with.keyword :text do |values|
        result = values
      end
    end
    assert_equal %w(this is some text), result
  end

  it "an empty search is successful" do
    result = nil
    KeywordSearch.search(%<>) do |with|
      with.default_keyword :text
      with.keyword :text do |values|
        result = values
      end
    end
    assert_nil result
  end

  it 'a negative search' do
    result = nil

    KeywordSearch.search(%<-site:google.com>) do |with|
      with.keyword :site do |values, positive|
        result = [ values, positive ]
      end
    end
    assert_equal [ [ 'google.com' ], false ], result
  end

  it 'a positive search' do
    result = nil

    KeywordSearch.search(%<+site:google.com>) do |with|
      with.keyword :site do |values, positive|
        result = [ values, positive ]
      end
    end
    assert_equal [ [ 'google.com' ], true ], result
  end

  it 'a search with no sign' do
    result = nil

    KeywordSearch.search(%<site:google.com>) do |with|
      with.keyword :site do |values, positive|
        result = [ values, positive ]
      end
    end
    assert_equal [ [ 'google.com' ], true ], result
  end

  it 'a term should default to positive with no sign' do
    result = nil

    KeywordSearch.search(%<-site:google.com inurl:atom>) do |with|
      with.keyword :inurl do |values, positive|
        result = [ values, positive ]
      end
    end
    assert_equal [ %w(atom), true ], result
  end

  it 'a negative and positive search to the default keyword' do
    result = []

    KeywordSearch.search(%<text -google.com search>) do |with|
      with.default_keyword :text
      with.keyword :text do |values, positive|
        result << [ values, positive ]
      end
    end
    assert_equal [ [ %w(text search), true ], [ %w(google.com), false ] ], result
  end

  it 'a negative search to the default keyword with quotes' do
    result = []

    KeywordSearch.search(%<-google.com>) do |with|
      with.default_keyword :text
      with.keyword :text do |values, positive|
        result << [ values, positive ]
      end
    end
    assert_equal [ [ %w(google.com), false ] ], result
  end

  it 'a search falling back to default values' do
    result = []

    KeywordSearch.search(%<>) do |with|
      with.keyword :some_flag, nil, "false" do |values, positive|
        result << [ values, positive ]
      end
    end

    assert_equal [ [ %w(false), true ] ], result
  end

  it 'a search should not use default values when explicit values present' do
    result = []

    KeywordSearch.search(%<some_flag:true>) do |with|
      with.keyword :some_flag, nil, "false" do |values, positive|
        result << [ values, positive ]
      end
    end

    assert_equal [ [ %w(true), true ] ], result
  end
end
