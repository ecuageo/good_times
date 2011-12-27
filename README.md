Paragon - Connecting couchrest functionality while keeping the couchdb paradigm

Purpose

Paragon strives to give an example of deriving your own needs from a simple couch wrapper like couchrest without giving into sequel like implimentations. Many of the abstractions provided by such libraries obfuscate the real interations with couch. You begin to impose a poor design on an excellent database. Instead, paragon gives you an example of creating simple abstractions that maintain the couch paradigm.

Installation

gem install paragon

require 'paragon'

Use

Inherit from Paragon and specify your document.

class NewMapper < Paragon
  setup_database("localhost:5984/new_mapper")
end

Setup_database will try to create a database if not already extant. It will also check if a design document named "_design/NewMapper" exists. Paragon sets a flag to later create this document with views you specify. setup_database must be call first before views. 

NewMapper descends from CouchRest::Document. You gain attributes and basic crud operations (read comes from get on the database object).

nm["first_att"] = "first"

nm.save                     # => 
NewMapper.get("id")         # => 
