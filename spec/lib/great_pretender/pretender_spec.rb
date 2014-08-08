require 'great_pretender/pretender'
require 'ostruct'

class PrefixSlugPretender
  def say_hello
    "Hello, guest!"
  end
end

class TestSlugPretender
  def ohai
    "ohai"
  end
end

describe GreatPretender::Pretender do

  let(:mockup) { OpenStruct.new(slug: "prefix_slug/test_slug") }
  let(:pretender) { GreatPretender::Pretender.new(mockup) }
  let(:recipient) do
    mod = pretender.to_module
    Class.new { include mod }.new
  end

  it "delegates methods to pretenders named after mockups" do
    expect(recipient.ohai).to eq("ohai")
  end

  it "delegates methods to pretenders in the slug chain" do
    expect(recipient.say_hello).to eq("Hello, guest!")
  end

end
