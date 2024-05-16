# frozen_string_literal: true

module PageMeta
  class HashMetaTag < MetaTag
    def render
      return if content.empty?

      content.each_with_object([]) do |(attr, value), buffer|
        value = value.call if value.respond_to?(:call)
        value = value.to_s

        next if value.blank?

        attr = attr.to_s.tr("_", ":")

        buffer << helpers.tag(
          :meta,
          property: "#{base_name}:#{attr}",
          content: value
        )
      end.join
    end
  end
end
