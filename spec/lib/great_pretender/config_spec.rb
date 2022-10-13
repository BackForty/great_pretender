# frozen_string_literal: true

require "spec_helper"

module GreatPretender; end

describe GreatPretender do
  describe ".config" do
    before { load("great_pretender/config.rb") }

    context "default configuration values" do
      it "has 'application' as the default layout" do
        expect(described_class.config.default_layout).to eq("application")
      end

      it "has 'mockups' as the default view path" do
        expect(described_class.config.view_path).to eq("mockups")
      end
    end

    it "accepts a block" do
      described_class.config do |c|
        c.default_layout = "another_layout"
        c.view_path = "somewhere"
      end
      expect(described_class.config.default_layout).to eq("another_layout")
      expect(described_class.config.view_path).to eq("somewhere")
    end

    it "can be used for direct setting of configuration options" do
      described_class.config.default_layout = "a_third_layout"
      expect(described_class.config.default_layout).to eq("a_third_layout")
    end
  end
end
