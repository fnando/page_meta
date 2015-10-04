module PageMeta
  class MetaTag
    class Og < MetaTag
      def render
        return if content.empty?

        content.each_with_object("") do |(attr, value), buffer|
          next if value.blank?
          attr = attr.to_s.gsub(/_/, ":")
          buffer << helpers.tag(:meta, property: "og:#{attr}", content: value)
        end
      end
    end
  end
end
