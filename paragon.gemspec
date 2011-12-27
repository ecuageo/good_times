$:.push File.expand_path("../lib", __FILE__)
require 'paragon/version'

Gem::Specification.new do |s|
  s.name        = 'paragon'
  s.version     = Paragon::VERSION
  s.date        = '2011-12-24'
  s.summary     = "Connecting couchrest functionality while keeping the couchdb paradigm"
  s.description = s.summary
  s.authors     = ["George South"]
  s.email       = 'ecuageo@gmail.com'

  s.add_dependency "couchrest", ">= 1.1.2"

  s.files       = ["lib/paragon.rb","lib/paragon/version.rb","lib/paragon/query_result.rb","lib/paragon/design_doc_helper.rb"]
  s.test_files  = ["spec/paragon_spec.rb"]
  s.homepage    = 'http://rubygems.org/gems/paragon'
end