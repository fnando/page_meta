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

    def singular_scope
      @singular_scope ||= scope == :keywords ? "keywords" : scope.to_s.singularize
    end

    def to_s
      return "" if simple.blank?

      [
        t("page_meta.#{scope}.base", value: simple, default: ""),
        t("page_meta.#{singular_scope}_base", value: simple, default: simple)
      ].reject(&:blank?).first || ""
    end

    def translation_scope
      [
        "page_meta.#{scope}.#{naming.controller}.#{naming.action}",
        "page_meta.#{naming.controller}.#{naming.action}.#{singular_scope}"
      ]
    end

    def simple
      override_options = options.merge(default: "")

      translation = ""

      translation_scope.each do |scope|
        translation = t("#{scope}_html", **override_options) if html
        translation = t(scope, **override_options) if translation.blank?

        break if translation.present?
      end

      translation
    end
  end
end
