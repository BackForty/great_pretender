require 'spec_helper'

require 'great_pretender/mockup'
require_relative '../../support/mockup_helpers'

describe GreatPretender::Mockup do

  include MockupHelpers

  let(:mockup) { mockup_locator.mockups.find {|m| m.slug =~ /admin/ } }
  let(:partial) { mockup_locator.mockups.find {|m| m.slug =~ /^_/ } }

  context ".name" do
    it "returns a human-readable name from its slug" do
      expect(mockup.name).to eq("Admin > Index")
    end

    it "marks a partial as such" do
      expect(partial.name).to eq("Partial (partial)")
    end
  end

  context ".to_param" do
    it "returns the slug" do
      expect(mockup.to_param).to eq(mockup.slug)
    end
  end

  context ".updated_at" do
    it "returns the template file's mtime for its slug" do
      `touch #{mockup.path}`
      expect(mockup.updated_at.to_i).to eq(Time.now.to_i)
    end
  end

end
