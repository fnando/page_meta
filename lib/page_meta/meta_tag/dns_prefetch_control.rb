# frozen_string_literal: true

module PageMeta
  class MetaTag
    class DnsPrefetchControl < MetaTag
      def render
        meta = helpers.tag(
          :meta,
          "http-equiv" => "x-dns-prefetch-control",
          content: "on"
        )

        link = helpers.tag(:link, rel: "dns-prefetch", href: content)

        meta + link
      end
    end
  end
end
