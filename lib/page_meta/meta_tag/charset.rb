module PageMeta
  class MetaTag
    class Charset < MetaTag
      def render
        return if content.empty?

        helpers.tag(:meta, charset: content)
      end
    end
  end
end
