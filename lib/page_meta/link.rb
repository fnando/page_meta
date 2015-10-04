module PageMeta
  class Link
    def self.build(rel, options)
      klass_name = "::PageMeta::Link::#{rel.to_s.camelize}"
      klass = const_get(klass_name) rescue Link
      klass.new(rel, options)
    end

    attr_reader :rel, :options

    def initialize(rel, options)
      @rel = rel.to_s.dasherize
      @options = options
    end

    def render
      helpers.tag(:link, options.merge(rel: rel)) unless options.empty?
    end

    def helpers
      ActionController::Base.helpers
    end
  end
end
