# frozen_string_literal: true

module PageMeta
  class Translator
    include ::ActionView::Helpers::TranslationHelper

    attr_reader :scope, :naming, :options, :html

    def initialize(scope, naming, options = {})
      @scope = scope
      @naming = naming
      @html = options[:html]
      @options = options
    end

    def to_s
      return "" if simple.blank?

      t("page_meta.#{scope}.base", value: simple, default: simple)
    end

    def translation_scope
      "page_meta.#{scope}.#{naming.controller}.#{naming.action}"
    end

    def simple
      override_options = options.merge(default: "")

      translation = t("#{translation_scope}_html", override_options) if html
      translation = t(translation_scope, override_options) if translation.blank?
      translation
    end
  end
end
