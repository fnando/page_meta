module PageMeta
  class MetaTag
    class Twitter < MetaTag
      def render
        return if content.empty?

        content.each_with_object("") do |(attr, value), buffer|
          next if value.blank?
          attr = attr.to_s.gsub(/_/, ":")
          buffer << helpers.tag(:meta, property: "twitter:#{attr}", content: value)
        end
      end
    end
  end
end
