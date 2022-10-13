# frozen_string_literal: true

module GreatPretender
  module MockupsHelper
    def great_pretender_mockup_path(mockup)
      if controller.is_a?(GreatPretender::MockupsController)
        great_pretender_engine.mockup_path(mockup)
      else
        path_helper = controller_path.split("/")
        path_helper = path_helper.join("_")
        path_helper = path_helper.singularize
        path_helper << "_url"
        begin
          send(path_helper, mockup)
        rescue NoMethodError => e
          error_message_subs = [controller_path, path_helper]
          error_message = I18n.t("great_pretender.missing_helper_methods") % error_message_subs
          raise MissingPathHelperError.new(error_message, e)
        end
      end
    end

    private

    # Trap calls to pretenders' names
    def method_missing(name, *args, &block)
      prefix = name.to_s.chomp("_pretender")
      if args.empty? && !block && (class_name = "#{prefix.classify}Pretender").safe_constantize
        class_eval <<-EOM, __FILE__, __LINE__ + 1
        def #{prefix}
          @great_pretender_pretender_#{prefix} ||= begin
            init = #{class_name}.instance_method(:initialize)
            init.arity == 1 ? #{class_name}.new(mockup) : #{class_name}.new
          end
        end
        EOM

        return send(prefix)
      end

      super
    end
  end

  class MissingPathHelperError < StandardError
    def initialize(message, error)
      super(message)
      @original_error = error # rubocop:disable Rails/HelperInstanceVariable
    end
  end
end
