module MockupHelpers
  def self.included(base)
    base.class_eval do

      let(:paths) do
        [
          Pathname.new("spec/fixtures/view_path_a").expand_path,
          Stub.new("spec/fixtures/view_path_b")
        ]
      end

      let(:mockup_locator) { GreatPretender::MockupLocator.new(paths) }

    end
  end

  class Stub
    def initialize(path)
      @path = path
    end

    def to_path
      @path.to_s
    end
  end
end
