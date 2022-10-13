# frozen_string_literal: true

require "great_pretender/mockup_locator"

module GreatPretender
  module Controller
    def self.included(base)
      base.helper GreatPretender::MockupsHelper
      base.helper_method :mockup_locator
      base.helper_method :mockup_root
    end

    def index
      render template: "great_pretender/index", layout: GreatPretender.config.default_layout
    end

    def show
      if mockup
        render template: mockup.template, layout: mockup.layout
      else
        error_message = I18n.t("great_pretender.not_found") % params[:id]
        raise ActiveRecord::RecordNotFound.new(error_message)
      end
    end

    private

    def mockup
      return @great_pretender_mockup if defined? @great_pretender_mockup
      @great_pretender_mockup = mockup_locator.find(params[:id])
    end

    def mockup_locator
      @great_pretender_mockup_locator ||= MockupLocator.new(view_paths)
    end

    def mockup_root
      @great_pretender_mockup_root ||= mockup_locator.view_paths.first.join(GreatPretender.config.view_path)
    end
  end
end
