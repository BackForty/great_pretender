module GreatPretender; end

describe GreatPretender do

  context ".config" do

    before { load("great_pretender/config.rb") }

    context "default configuration values" do

      it "has 'application' as the default layout" do
        expect(GreatPretender.config.default_layout).to eq("application")
      end

      it "has 'mockups' as the default view path" do
        expect(GreatPretender.config.view_path).to eq("mockups")
      end

    end

    it "accepts a block" do
      GreatPretender.config do |c|
        c.default_layout = "another_layout"
        c.view_path = "somewhere"
      end
      expect(GreatPretender.config.default_layout).to eq("another_layout")
      expect(GreatPretender.config.view_path).to eq("somewhere")
    end

    it "can be used for direct setting of configuration options" do
      GreatPretender.config.default_layout = "a_third_layout"
      expect(GreatPretender.config.default_layout).to eq("a_third_layout")
    end

  end

end
