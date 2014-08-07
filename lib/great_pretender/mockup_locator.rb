require "great_pretender/config"
require "great_pretender/mockup"

module GreatPretender
  class MockupLocator

    attr_reader :view_paths

    def find(slug)
      mockups.find {|mockup| mockup.slug == slug}
    end

    def mockups
      return @mockups if defined? @mockups
      mockups = []
      @view_paths.each do |view_path|
        root = view_path.join(GreatPretender.config.view_path)
        templates = Dir[root.join("**/*.#{extensions}")]
        templates.each do |path|
          mockup = Mockup.new(path)
          mockup.slug = slug_for(root, path)
          mockup.layout = layout_for(mockup.slug)
          mockup.template = template_for(view_path, root, mockup.slug)
          mockups.push(mockup)
        end
      end
      @mockups = mockups
    end

    def initialize(view_paths)
      @view_paths = view_paths.map do |view_path|
        if view_path.is_a?(Pathname)
          view_path
        elsif view_path.respond_to?(:to_path)
          Pathname.new(view_path.to_path)
        else
          Pathname.new(view_path.to_s)
        end
      end
    end

    private

    def extensions
      return @extensions if defined? @extensions
      extensions = ActionView::Template.template_handler_extensions
      extensions = extensions.map(&:to_s).join(',')
      @extensions = "{#{extensions}}"
    end

    def layout_for(slug)
      if File.basename(slug) =~ /^_/
        # Partials (named like "_template_name") don't render inside a layout.
        # This way they can be used w/Ajax requests, etc.
        nil
      else
        # Mockups can have a layout by being in a folder named after that
        # layout; for example, "app/views/mockups/admin/index" will look for an
        # "admin" template
        layout = slug.split('/').first
        if layout && layout.length > 0
          @view_paths.each do |view_path|
            layout_path = view_path.join('layouts')
            layout_path = layout_path.join("#{layout}.*#{extensions}")
            return layout if Dir[layout_path].any?
          end
        end
        GreatPretender.config.default_layout
      end
    end

    def slug_for(root, path)
      slug = path.to_s.gsub(%r{^#{root.to_s}/}, '')
      while (ext = File.extname(slug)).length > 0
        slug = slug.gsub(/#{ext}$/, '')
      end
      slug
    end

    def template_for(view_path, root, slug)
      template_root = root.relative_path_from(view_path)
      template_root.join(slug).to_s
    end

  end
end
