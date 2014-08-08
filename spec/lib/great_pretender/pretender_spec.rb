require 'spec_helper'

require 'great_pretender/pretender'
require 'ostruct'

class PrefixSlugPretender
  def say_hello
    "Hello, guest!"
  end

  def name
    "Flip"
  end
end

class TestSlugsPretender
  attr_reader :mockup

  def initialize(mockup)
    @mockup = mockup
  end

  def ohai
    "ohai"
  end

  def name
    "Avery"
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

  it "delegates methods to the most specific responder" do
    expect(recipient.name).to eq("Avery")
  end

  it "passes the mockup to pretenders that accept an initialization argument" do
    expect(TestSlugsPretender).to receive(:new).with(mockup)
    recipient
  end

  it "correctly calls super when a method doesn't exist" do
    expect(-> { recipient.foobar }).to raise_error(NoMethodError)
  end

  it "quietly flunks mockups without pretenders" do
    pretenderless_mockup = OpenStruct.new(slug: "no_pretender_mockup")
    expect(-> { GreatPretender::Pretender.new(pretenderless_mockup) } ).not_to raise_error
  end
end
