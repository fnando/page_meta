# frozen_string_literal: true

module PageMeta
  class MetaTag
    class Title < MetaTag
      def render
        helpers.tag(:meta, name: "DC.title", content: content.simple) +
          helpers.tag(:meta, itemprop: "name", content: content.simple)
      end
    end
  end
end
