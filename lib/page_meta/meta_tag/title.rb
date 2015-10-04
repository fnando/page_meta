module PageMeta
  class MetaTag
    class Title < MetaTag
      def render
        helpers.content_tag(:title, content) +
        helpers.tag(:meta, name: "DC.title", content: content) +
        helpers.tag(:meta, itemprop: "name", content: content)
      end
    end
  end
end
