# Arnold [![Build Status](http://travis-ci.org/codebrawl/arnold.png)](http://travis-ci.org/codebrawl/arnold)

A terminal admin interface.

## Usage
Just put your favourite text-editor in `ENV['EDITOR']` (vi is the default one).

``` ruby
  post = Post.find(1)
  post.edit # The editor pops out, make the changes and save!
  post.save
```

Alternatively, `edit!` saves the changes immediately to the database.

## Supported ORMs
* ActiveRecord
* Mongoid

