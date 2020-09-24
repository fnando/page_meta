# frozen_string_literal: true

module PageMeta
  class MetaTag
    attr_reader :name, :content

    def self.build(name, content)
      klass_name = "::PageMeta::MetaTag::#{name.to_s.camelize}"
      klass = begin
        const_get(klass_name)
      rescue ActionView::Template::Error, NameError
        MetaTag
      end
      klass.new(name, content)
    end

    def initialize(name, content)
      @name = name.to_s.dasherize
      @content = content
    end

    def render
      helpers.tag(:meta, name: name, content: content) unless content.empty?
    end

    def helpers
      ActionController::Base.helpers
    end

    class MultipleMetaTag < MetaTag
      def render
        return if content.empty?

        helpers.tag(:meta, name: name, content: content) +
          helpers.tag(:meta, itemprop: name, content: content)
      end
    end

    class HttpEquiv < MetaTag
      def render
        return if content.empty?

        helpers.tag(:meta, "http-equiv" => name, content: content)
      end
    end

    class Description < MultipleMetaTag; end
    class Author < MultipleMetaTag; end
    class Keywords < MultipleMetaTag; end

    class Pragma < HttpEquiv; end
    class CacheControl < HttpEquiv; end
    class Imagetoolbar < HttpEquiv; end
    class Expires < HttpEquiv; end
    class Refresh < HttpEquiv; end
  end
end
