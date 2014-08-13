require 'spec_helper'

require 'great_pretender/pretender'
require 'i18n'
require 'ostruct'

module Rails
  def self.logger
    @logger ||= Class.new do
      def debug(msg)
        puts msg
      end
    end.new
  end
end

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


I18n.load_path = Dir['config/locales/*.yml']
I18n.enforce_available_locales = false

describe GreatPretender::Pretender do

  let(:mockup) { OpenStruct.new(slug: "prefix_slug/test_slug") }
  let(:pretender) { GreatPretender::Pretender.new(mockup) }
  let(:recipient) do
    mod = pretender.to_module
    Class.new { include mod }.new
  end

  let(:deprecation_warning) { }

  before do |example, options|
    if example.metadata[:deprecations]
      deprecation_warning = I18n.t('great_pretender.deprecated_pretender')
      deprecation_warning = deprecation_warning % example.metadata[:deprecations]
      expect(Rails.logger).to receive(:debug).with(deprecation_warning)
    end
  end

  it "delegates methods to pretenders named after mockups", deprecations: %w(ohai test_slugs ohai) do
    expect(recipient.ohai).to eq("ohai")
  end

  it "delegates methods to pretenders in the slug chain", deprecations: %w(say_hello prefix_slug say_hello) do
    expect(recipient.say_hello).to eq("Hello, guest!")
  end

  it "delegates methods to the most specific responder", deprecations: %w(name test_slugs name) do
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
