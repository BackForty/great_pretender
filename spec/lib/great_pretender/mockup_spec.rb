require 'great_pretender/mockup'
require_relative '../../support/mockup_helpers'

describe GreatPretender::Mockup do

  include MockupHelpers

  let(:mockup) { mockup_locator.mockups.find {|m| m.slug =~ /admin/ } }

  it "returns a human-readable name from its slug" do
    expect(mockup.name).to eq("Admin > Index")
  end

  context ".to_param" do
    it "returns the slug" do
      expect(mockup.to_param).to eq(mockup.slug)
    end
  end

  context ".updated_at" do
    it "returns the template file's mtime for its slug" do
      expect(mockup.updated_at).to eq(Time.at(1407427839))
    end
  end

end
