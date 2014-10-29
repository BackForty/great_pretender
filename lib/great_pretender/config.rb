module GreatPretender

  class Config

    attr_accessor :default_layout, :path_separator, :view_path
    attr_writer :base_controller

    def base_controller
      @base_controller ||= ::ApplicationController
    end

  end

  def self.config
    @config ||= Config.new
    if block_given?
      yield @config
    end
    @config
  end

end

GreatPretender.config do |c|
  c.default_layout = 'application'
  c.path_separator = ' > '
  c.view_path = 'mockups'
end
