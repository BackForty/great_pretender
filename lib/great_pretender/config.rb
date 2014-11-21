module GreatPretender

  class Config

    attr_accessor :default_layout, :path_separator, :view_path

    def base_controller
      @base_controller ||= "::ApplicationController"
      @base_controller.constantize
    end

    def base_controller=(new_base_controller)
      @base_controller = new_base_controller.to_s
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
