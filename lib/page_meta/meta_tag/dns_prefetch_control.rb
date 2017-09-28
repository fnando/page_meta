# frozen_string_literal: true

module PageMeta
  class MetaTag
    class DnsPrefetchControl < MetaTag
      def render
        helpers.tag(:meta, "http-equiv" => "x-dns-prefetch-control", content: "on") +
          helpers.tag(:link, rel: "dns-prefetch", href: content)
      end
    end
  end
end
