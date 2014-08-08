require "great_pretender/mockup_locator"
require "great_pretender/pretender"

module GreatPretender
  module Controller

    def self.included(base)
      base.helper_method :mockup
      base.helper_method :mockups
      base.helper_method :mockup_root
      base.helper GreatPretender::MockupsHelper
    end

    def index
      render template: 'great_pretender/index'
    end

    def show
      if mockup
        render template: mockup.template, layout: mockup.layout
      else
        error_message = I18n.t('great_pretender.not_found') % params[:id]
        raise ActiveRecord::RecordNotFound.new(error_message)
      end
    end

    private

    def mockup
      @great_pretender_mockup ||= mockup_locator.find(params[:id])
    end

    def mockups
      @great_pretender_mockups ||= mockup_locator.mockups
    end

    def mockup_locator
      @great_pretender_mockup_locator ||= MockupLocator.new(view_paths)
    end

    def mockup_root
      @great_pretender_mockup_root ||= mockup_locator.view_paths.first.join(GreatPretender.config.view_path)
    end

    def pretender
      @great_pretender_pretender ||= Pretender.new(mockup)
    end

    def view_context
      super.tap do |view_context|
        view_context.extend pretender.to_module if mockup
      end
    end

  end
end
