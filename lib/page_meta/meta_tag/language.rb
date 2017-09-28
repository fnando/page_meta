# frozen_string_literal: true

module PageMeta
  class MetaTag
    class Language < MetaTag
      def render
        helpers.tag(:meta, name: name, content: content) +
          helpers.tag(:meta, itemprop: name, content: content)
      end
    end
  end
end
