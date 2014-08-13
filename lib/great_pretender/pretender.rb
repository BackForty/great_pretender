require "active_support/core_ext/string/inflections"

module GreatPretender
  class Pretender

    def initialize(mockup)
      @mockup = mockup
    end

    def to_module
      pretenders = load_pretenders

      Module.new do
        define_method(:method_missing) do |method_name, *args, &block|
          pretender = pretenders.find { |p| p.respond_to?(method_name) }

          if pretender
            if defined? Rails
              deprecation_warning = I18n.t('great_pretender.deprecated_pretender')
              deprecation_warning_args = [method_name, pretender.class.name.underscore.gsub(/_pretender$/, ''), method_name]
              Rails.logger.debug deprecation_warning % deprecation_warning_args
            end
            pretender.send(method_name, *args, &block)
          else
            super(method_name, *args, &block)
          end
        end
      end
    end

    private

    def load_pretender(class_name)
      class_name = class_name + 'Pretender'
      begin
        klass = class_name.constantize
      rescue NameError
        return nil
      end

      initialize = klass.instance_method(:initialize)

      if initialize.arity == 1
        klass.new(@mockup)
      else
        klass.new
      end
    end

    def load_pretenders
      pretenders = []
      @mockup.slug.split("/").each do |pretender_name|
        # Given a mockup named something like 'social_contents',
        # support pretenders named 'SocialContentsPretender' AND 'SocialContentPretender'
        singular_class = pretender_name.classify
        plural_class = singular_class.pluralize

        [singular_class, plural_class].each do |class_name|
          if instance = load_pretender(class_name)
            pretenders.push(instance)
          end
        end
      end
      pretenders.reverse
    end

  end
end
