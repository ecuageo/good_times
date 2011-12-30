$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rspec'

require 'good_times'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  alias :running :lambda
  config.fail_fast = true
end

COUCH_URL = "http://127.0.0.1:5984"
TESTDB_NAME = "good_times-test"
TEST_SERVER = CouchRest.new(COUCH_URL)
TESTDB = TEST_SERVER.database(TESTDB_NAME)

RSpec.configure do |config|
  config.before(:all) { recreate_test_db }
  config.after(:all) { tear_down_test_dbs }
end

def recreate_test_db
  TESTDB.recreate! rescue nil
  TESTDB
end

def tear_down_test_dbs
  test_dbs = TEST_SERVER.databases.select {|db| db =~ /test$/}
  test_dbs.each {|db| TEST_SERVER.database(db).delete! rescue nil }
end
