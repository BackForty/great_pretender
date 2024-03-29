# frozen_string_literal: true

require "active_support/core_ext/string/inflections"
require "great_pretender/config"

module GreatPretender
  class Mockup
    attr_accessor :layout, :path, :slug, :template

    alias_method :to_param, :slug

    def initialize(path)
      @file = Pathname.new(path)
    end

    def name
      return @name if defined? @name
      name = slug.split("/").map { |s| s.titleize }.join(GreatPretender.config.path_separator)
      if /^_/.match?(slug)
        name << " (partial)"
      end
      @name = name.strip
    end

    def updated_at
      @file.mtime
    end
  end
end
