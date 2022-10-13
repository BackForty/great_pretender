# frozen_string_literal: true

if ENV["CODECLIMATE_REPO_TOKEN"]
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
else
  require "simplecov"
  SimpleCov.start "rails" do
    add_filter "spec"
  end
end
