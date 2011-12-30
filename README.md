Good Times - Connecting couchrest functionality while keeping the couchdb paradigm

Purpose

Good Times strives to give an example of deriving your own needs from a simple couch wrapper like couchrest without giving into sequel like implimentations. Many of the abstractions provided by such libraries obfuscate the real interations with couch. You begin to impose a poor design on an excellent database. Instead, Good Times gives you an example of creating simple abstractions that maintain the couch paradigm.

Installation

gem install good_times

require 'good_times'

Use

Inherit from GoodTimes and specify your document.

class NewMapper < GoodTimes
  setup_database("localhost:5984/new_mapper")
end

Setup_database will try to create a database if not already extant. It will also check if a design document named "_design/NewMapper" exists. Good Times sets a flag to later create this document with views you specify. setup_database must be call first before views. 

NewMapper descends from CouchRest::Document. You gain attributes and basic crud operations (read comes from get on the database object).

nm["first_att"] = "first"

nm.save                     # => 
NewMapper.get("id")         # => 
