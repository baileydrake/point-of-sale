require 'activerecord'
require 'pg'
require 'rspec'
require 'shoulda-matchers'

ActiveRecord::Base.establish_connection(YAML::load(File.open('./db/config.yml'))["test"])

RSpec.configure do |config|
  config.after(:each) do

