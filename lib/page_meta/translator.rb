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
      @singular_scope ||= if scope == :keywords
                            "keywords"
                          else
                            scope.to_s.singularize
                          end
    end

    def to_s
      return "" if simple.blank?

      value = simple

      [
        # Set base scope for controller
        t(
          "page_meta.#{naming.controller}.#{singular_scope}_base",
          value:,
          **override_options
        ),

        # Set base scope for action
        t(
          "page_meta.#{naming.controller}.#{naming.action}." \
          "#{singular_scope}_base",
          value:,
          **override_options
        ),

        # Set old style base scope
        t("page_meta.#{scope}.base", value:, **override_options),

        # Set base scope
        t("page_meta.#{singular_scope}_base", value:, **override_options,
                                              default: value)
      ].reject(&:blank?).first || ""
    end

    def translation_scope
      [
        "page_meta.#{scope}.#{naming.controller}.#{naming.action}",
        "page_meta.#{naming.controller}.#{naming.action}.#{singular_scope}"
      ]
    end

    def override_options
      options.merge(default: "")
    end

    def simple
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
