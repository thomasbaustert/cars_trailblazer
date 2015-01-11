ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

# TODO/29.12.14/05:55/tb do we need this?
require 'car_registration/crud'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'

  # TODO/11.01.15/04:23/tb remove later
  config.infer_spec_type_from_file_location!
end

def build_master_user(attrs = {})
  User.new(firstname: "Manfred", lastname: "Master", email: "master@example.org", role: 'master')
end

def build_user(attrs = {})
  User.new(firstname: "Uli", lastname: "User", email: "uli@example.org", role: 'user')
end