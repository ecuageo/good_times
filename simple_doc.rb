require 'rubygems'
#require_relative 'lib/good_times'
require 'good_times'

class SimpleDoc < GoodTimes

  use_database CouchRest.database!("127.0.0.1:5984/simple_doc")

  views_setup({
    "by_id_with_1" => {
      "map" => "function(doc) { emit(doc._id,1) }",
      "reduce" => "function(keys, values, rereduce) {return sum(values)}"
    },
    "by_contract_id_with_1" => {
      "map" => "function(doc) {if (doc['contract_id'] != null) { emit(doc['contract_id'], 1) }}"
    }
  })

  query :all, :by_id_with_1, {:include_docs => true}
  query :count, :by_id_with_1, {:reduce => true}
  query :by_contract_id, :by_contract_id_with_1, {:include_docs => true}

end
