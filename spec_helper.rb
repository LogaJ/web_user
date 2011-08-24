$:.unshift(File.join(File.dirname(__FILE__), '..', "roles"))
require 'rspec'

WORKING_DIR = File.dirname(__FILE__)
TEST_DATA_DIR = WORKING_DIR + '/test_data'
