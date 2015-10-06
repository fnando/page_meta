module PageMeta
  class MetaTag
    class Title < MetaTag
      def render
        helpers.content_tag(:title, content.to_s) +
        helpers.tag(:meta, name: "DC.title", content: content.simple) +
        helpers.tag(:meta, itemprop: "name", content: content.simple)
      end
    end
  end
end
