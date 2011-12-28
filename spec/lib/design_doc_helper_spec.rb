require 'spec_helper'

class Example < CouchRest::Document
  include DesignDocHelper
end

describe DesignDocHelper do
  describe ".use_database" do
    it "should set @design if a design doc exists" do
      #given
      TESTDB.save_doc({"_id" => "_design/example"})

      #when
      Example.use_database(TESTDB)

      #then
      Example.instance_variable_get("@design").should_not == nil
    end
    it "should set @design to nil if no design doc exists" do
      # given
      Example.database.get("_design/example").destroy rescue nil

      # when
      Example.use_database(TESTDB)

      # then
      Example.instance_variable_get("@design").should == nil
    end
  end
  describe ".views_setup" do
    before :each do
      Example.database.get("_design/example").destroy rescue nil
    end

    it "should create a design doc if none exist" do
      # when
      Example.views_setup({"by_id_with_1" => {"map" => "function(doc) { emit(doc._id,1) }"}})

      # then
      Example.database.get("_design/example").should_not == nil
    end

    it "should change the db design doc if different" do
      # given
      Example.database.save_doc("_id" => "_design/example", "views" => {
                                  "by_rev" =>  {
                                    "map" =>  "function(doc) { emit(doc._rev,1) }",
                                    "reduce" => "function(keys, values, rereduce) {return sum(values)}"
                                  }
                                })
      Example.use_database(TESTDB) # this resets @design to what exists in the database

      # when
      Example.views_setup({"by_id" => {"map" => "function(doc) { emit(doc._id,1) }"}})

      # then
      Example.views["by_id"].should_not == nil
      Example.views["by_rev"].should == nil
    end
  end

end
