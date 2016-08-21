require 'capybara'
require 'capybara/dsl'

Capybara.configure do |c|
    c.run_server = false
    c.default_driver = :selenium
    c.app_host = "http://localhost:3000"
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.include  Capybara::DSL
end
