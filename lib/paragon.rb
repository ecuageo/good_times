require 'json/ext'
require 'couchrest'
require_relative 'paragon/query_result'
require_relative 'paragon/design_doc_helper'

class Paragon < CouchRest::Document

  include DesignDocHelper

  class << self

    # alias :find :get

    def query(method, view, options)
      meta = class << self; self end
      meta.instance_eval {
        send(:define_method,"query_#{method.to_s}") do |*opts|
          results = @design.view(view, options.merge(opts.first || {}))
          if options[:include_docs] 
            results["rows"].map! {|row| self.new(row["doc"]) }
          end
          QueryResult.new(results)
        end
      }
    end

    def get(id)
      new database.get(id) rescue nil
    end

  end

end


