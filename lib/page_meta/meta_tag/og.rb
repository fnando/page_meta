# frozen_string_literal: true

module PageMeta
  class MetaTag
    class Og < HashMetaTag
      def base_name
        "og"
      end
    end
  end
end
