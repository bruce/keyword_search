Keyword Search
==============

[![Build Status](https://travis-ci.org/bruce/keyword_search.png)](https://travis-ci.org/bruce/keyword_search)

Description
-----------

Generic library to parse GMail-style search strings for keyword/value pairs;
supports definition of valid keywords and handling of quoted values.

Requirements
------------

None.

Features
--------

The library features a very simple, easy-to-use API.

 * Define handlers for supported keywords with blocks
 * Define the default keyword (values not part of a keyword/value pair)
 * Handle negation

Please see the example provided below.

Synopsis
--------

Here's an example using ActiveRecord (though the library is generic, and can
be used for any Ruby project).  The library isn't limited to search terms, as
shown in this example; how you use it is up to you.

First, let's build up some variables we'll be populating for a SQL query.

```ruby
clauses = []
arguments = []
```

Now let's set an example string to parse.  Presumably you'd get this from
a form (ie, `params[:terms]`) or some other form of input.

```ruby
terms = 'account has:attachment since:2006-12-03 -description:crazy'
```

Now let's do the search, defining the handlers to deal with each keyword.

```ruby
KeywordSearch.search(terms) do |with|

  # This sets the keyword handler for bare words in the string,
  # ie "account" in our example search terms
  with.default_keyword :title

  # Here's what we do when we encounter a "title" keyword
  with.keyword :title do |values|
    clauses << "title like ?"
    arguments << "%#{values.join(' ')}%"
  end

  # For "has," we check the value provided (and only support "attachment")
  with.keyword :has do |values|
    clauses << 'has_attachment = true' if values.include?('attachment')
  end

  # Here we do some date parsing
  with.keyword :since do |values|
    date = Date.parse(values.first) # only support one
    clauses << 'created_on >= ?'
    arguments << date.to_s
  end

  # If a second parameter is defined for a block, you can handle negation.
  # In this example, we don't want results whose description includes
  # the word "crazy"
  with.keyword :description do |values, positive|
    clauses << "description #{'not' unless positive} like ?"
    arguments << "%#{values.join(' ')}%"
  end

end
```

Immediately after the block is defined, the string is parsed and handlers
fire.  Due to the magic of closures, we now have populated variables we can
use to build a real SQL query.

```ruby
query = clauses.map { |c| "(#{c})" }.join(' AND ')
conditions = [query, *arguments]
results = Message.all(:conditions => conditions)
```

Installation
------------

```
gem install keyword_search
```

License
-------

See LICENSE.

Legal Notes
-----------

GMail is copyright Google, Inc.