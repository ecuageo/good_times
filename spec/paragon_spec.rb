require 'rubygems'
require 'rspec'
require 'rest-client'
require_relative 'couch_mapper'

COUCHDB_URL = "localhost:5984/new_mapper"

class NewMapper < CouchMapper
  set_database COUCHDB_URL
end

def reset_db
  RestClient.delete(COUCHDB_URL)
end

describe NewMapper do
  before :each do
    reset_db
  end
  describe ".new" do
    it "should initialize a new instance given the key value pairs passed" do
      nm = NewMapper.new("attributes" => {"sample_field" => "a string field", "another_field" => 2})
      nm.sample_field.should == "a string field"
      nm.another_field.should == 2
    end
  end

  describe ".get" do
    it "should retrieve a document by id" do
      RestClient.put(COUCHDB_URL + "/1234", {"some_key" => "some value"})
      nm = NewMapper.get("1234")
      nm.class.should == NewMapper
      nm.some_key.should == "some value"
    end
    it "should return nil if no document exists" do
      nm = NewMapper.get("nonexistent")
      nm.should == nil
    end
  end

  describe "#set_database" do
    it "should setup a database object in NewMapper" do
      class TestMapper < CouchMapper; set_database(COUCHDB_URL); end
      TestMapper.database.class.should == CouchRest::Database
    end
    it "should warn when no database is present" do
      class TestMapper < CouchMapper; end
      lambda {TestMapper.database }.should raise_error(RuntimeError, "You must define a database connection with set_database")
    end
  end

  describe "#save" do
    context "a new document" do
      it "should create a new document in the database" do
        nm = NewMapper.new("attributes" => {"mapper_key" => "mapper_value", "_id" => "mapper1"}).save
        rc = RestClient.get("mapper1")
        rc.should != nil
        rc.mapper_key.should == "mapper_value"
      end
    end
    context "an existing document" do
      it "should update the existing document from the database" do
        RestClient.put(COUCHDB_URL + "/1234", {:some_key => "some value"})
        nm = NewMapper.get("1234")
        nm.new_key = "new_value"
        nm.save
        RestClient.get(COUCHDB_URL + "/1234")["new_key"].should == "new_value"
      end
    end
  end
end
