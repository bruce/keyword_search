keyword_search
    http://codefluency.rubyforge.org/keyword_search
    by Bruce Williams

== DESCRIPTION:
  
Generic library to parse GMail-style search strings for keyword/value pairs; supports definition of valid keywords and handling of quoted values.

== FEATURES/PROBLEMS:
  
The library features a very simple, easy-to-use API.
* Define handlers for supported keywords with blocks
* Define the default keyword (values not part of a keyword/value pair)

Various notes:
* Quoted values are supported.
* Input is automatically downcased (both keywords and values should be assumed to be in lowercase)

Development Roadmap:
1.1:: Expand supported character set for keywords and values
      (currently supports a-z)
2.0:: Add negation and grouping (will break API backwards compatibility)

== SYNOPSIS:

Here's an example of usage from Rails (though the library is generic, and could presumably be used for any Ruby project)

  # Some variables to build up
  clauses = []
  arguments = []

  # Search a string, defining the supported keywords and building up
  # the variables in the associated closures
  
  KeywordSearch.search('account has:attachment since:2006-12-03') do |with|

    with.default_keyword :title
  
    with.keyword :title do |values|
      clauses << "title like ?"
      arguments << "%#{values.join(' ')}%"
    end
  
    with.keyword :has do |values|
      clauses << 'has_attachment = true' if values.include?('attachment')
    end
  
    with.keyword :since do |values|
      date = Date.parse(values.first) # only support one
      clauses << 'created_on >= ?'
      arguments << date.to_s
    end
  
  end
  
  # Do our search with <tt>clauses</tt> and <tt>arguments</tt>
  conditions = [clauses.map{|c| "(#{c})"}.join(' AND ')), *arguments] # simplistic example
  results = Message.find(:all, :conditions => conditions)

== REQUIREMENTS:

* dhaka
* hoe

== INSTALL:

sudo gem install keyword_search

== LICENSE:

(The MIT License)

Copyright (c) 2007 Bruce Williams

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

== LEGAL NOTES

GMail is copyright Google, Inc.