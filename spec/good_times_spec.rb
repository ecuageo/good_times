require 'spec_helper'

class NewMapper < GoodTimes
  use_database TESTDB
end

describe GoodTimes do
  describe ".query" do

    before :each do
      NewMapper.views_setup("by_id" => {"map" => "function(doc) { emit(doc._id, null) } "})
      NewMapper.query(:all, :by_id, {:include_docs => true})
    end

    it "returns a QueryResult object" do
      NewMapper.query_all.should be_an_instance_of(QueryResult)
    end

    it "calls a specific view on a design doc" do
      # expect
      NewMapper.instance_variable_get("@design").should_receive(:view).with(:by_id, anything()).and_return({"total_rows"=>0, "offset"=>0, "rows"=>[]})

      # when
      NewMapper.query_all
    end

    it "defines new methods on the class" do
      NewMapper.should respond_to(:query_all)
    end

  end

  it "should have CouchRest::Document as its ancestor" do
    NewMapper.ancestors.should include(CouchRest::Document)
  end

  describe ".get" do
    it "should retrieve a document by id" do
      TESTDB.save_doc({"_id" => "1234"})
      nm = NewMapper.get("1234")
      nm.class.should == NewMapper
      nm["_id"].should == "1234"
    end
    it "should return nil if no document exists" do
      nm = NewMapper.get("nonexistent")
      nm.should == nil
    end
  end

end
