# frozen_string_literal: true

require "ostruct"

module MockupHelpers
  def self.included(base)
    base.class_eval do
      let(:paths) do
        [
          Pathname.new("spec/fixtures/view_path_a").expand_path,
          OpenStruct.new(to_path: "spec/fixtures/view_path_b"),
          OpenStruct.new(to_s: "spec/fixtures/view_path_c"),
        ]
      end

      let(:mockup_locator) { GreatPretender::MockupLocator.new(paths) }
    end
  end
end
