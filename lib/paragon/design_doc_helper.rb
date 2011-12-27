#   DesignDocHelper makes the following assumptions:
#     1) if you don't have a design doc created and you call views it will create that for you
#     2) when looking at your views, you will get the doc["views"] initially pulled from database, this means you can alter the design doc by hand after the class is loaded and DesignDocHelper won't know. Views are indexes created in the database. Any mismatch will resolve to what is in the db.
#     3) the views macro can only be called after a database has been specified (through use_database)
#     4) views specified in you class will overwrite the views in your couchdb
#     5) you will keep anything else already defined (lists, shows, etc)

module DesignDocHelper

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def use_database(db)
      super
      @design =
        begin
          database.get("_design/#{design_doc_name}")
        rescue RestClient::ResourceNotFound
          nil
        end
    end

    # must be called only after use_database has been called
    def views_setup(views)
      initialize_design_doc(views) and return unless @design
      if @design["views"] != views
        update_design_doc(views)
      end
    end

    def views
      @design["views"] if @design
    end

    def initialize_design_doc(views)
      @design = CouchRest::Design.new
      @design.name = design_doc_name
      @design.database = database
      @design["views"] = views
      @design.save
    end

    def update_design_doc(views)
      @design['views'] = views
      @design.save
    end

    def design_doc_name
      self.name.downcase
    end
  end

end
