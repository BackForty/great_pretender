# frozen_string_literal: true

module GreatPretender
  class Engine < ::Rails::Engine
    config.generators do |g|
      g.test_framework :rspec
    end

    config.autoload_paths.push(Pathname.new("").join("app", "pretenders").expand_path.to_s)
  end
end
