$:.push File.expand_path("../lib", __FILE__)
require 'good_times/version'

Gem::Specification.new do |s|
  s.name        = 'good_times'
  s.version     = GoodTimes::VERSION
  s.date        = '2011-12-24'
  s.summary     = "Connecting couchrest functionality while keeping the couchdb paradigm"
  s.description = s.summary
  s.authors     = ["George South"]
  s.email       = 'ecuageo@gmail.com'

  s.add_dependency "couchrest", ">= 1.1.2"

  s.files       = ["lib/good_times.rb","lib/good_times/version.rb","lib/good_times/query_result.rb","lib/good_times/design_doc_helper.rb"]
  s.test_files  = ["spec/good_times_spec.rb"]
  s.homepage    = 'http://rubygems.org/gems/good_times'
end