# frozen_string_literal: true

module PageMeta
  class Translator
    attr_reader :scope, :naming, :options

    def initialize(scope, naming, options = {})
      @scope = scope
      @naming = naming
      @options = options
    end

    def to_s
      return "" if simple.blank?
      I18n.t("page_meta.#{scope}.base", value: simple, default: simple)
    end

    def simple
      I18n.t(
        "page_meta.#{scope}.#{naming.controller}.#{naming.action}",
        options.merge(default: "")
      )
    end
  end
end
