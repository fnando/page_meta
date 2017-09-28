# frozen_string_literal: true

module PageMeta
  class MetaTag
    class Charset < MetaTag
      def render
        return if content.blank?

        helpers.tag(:meta, charset: content.to_s.upcase)
      end
    end
  end
end
