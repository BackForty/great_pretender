module GreatPretender
  module MockupsHelper

    def great_pretender_mockup_path(mockup)
      if controller.is_a?(GreatPretender::MockupsController)
        great_pretender_engine.mockup_path(mockup)
      else
        path_helper = controller_path.split("/")
        path_helper = path_helper.join("_")
        path_helper = path_helper.singularize
        path_helper << '_url'
        begin
          send(path_helper, mockup)
        rescue NoMethodError => error
          error_message_subs = [controller_path, path_helper]
          error_message = I18n.t('great_pretender.missing_helper_methods') % error_message_subs
          raise MissingPathHelperError.new(error_message, error)
        end
      end
    end
  end

  class MissingPathHelperError < StandardError
    def initialize(message, error)
      super(message)
      @original_error = error
    end
  end
end
