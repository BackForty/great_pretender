require 'spec_helper'

require 'great_pretender/mockup_locator'
require 'pathname'
require_relative '../../support/mockup_helpers'

module ActionView
  module Template
    def self.template_handler_extensions
      %w(erb slim haml)
    end
  end
end

describe GreatPretender::MockupLocator do

  include MockupHelpers

  let(:regular_mockup) { mockup_locator.mockups.find {|m| m.slug =~ /^processed/ } }
  let(:partial_mockup) { mockup_locator.mockups.find {|m| m.slug =~ /^_/ } }
  let(:admin_mockup) { mockup_locator.mockups.find {|m| m.slug =~ /admin/ } }

  context "::mockups" do
    it "returns all mockups in the pre-configured mockup directories" do
      expect(mockup_locator.mockups.size).to eq(5)
    end

    it "returns mockups with Rails-friendly template names" do
      expect(regular_mockup.template).to eq("mockups/processed")
    end

    it "returns mockups with the default layout if they have no discernible alternative" do
      expect(regular_mockup.layout).to eq(GreatPretender.config.default_layout)
    end

    it "returns partials with no layout" do
      expect(partial_mockup.layout).to be_nil
    end

    it "returns detected layouts for well-named mockups" do
      expect(admin_mockup.layout).to eq("admin")
    end
  end

  context "::find" do
    it "returns mockups given a slug" do
      expect(mockup_locator.find("processed")).to eq(regular_mockup)
    end

    it "returns nil given a bad mockup name" do
      expect(mockup_locator.find("foobar")).to be_nil
    end
  end
end
