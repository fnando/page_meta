# frozen_string_literal: true

module PageMeta
  class Base
    DEFAULT_META_TAGS = %i[
      language
      charset
      title
      keywords
      description
      viewport
    ].freeze

    attr_reader :controller, :store

    delegate :[], :[]=, to: :store

    def initialize(controller)
      @controller = controller
      @description = {}
      @store = {}
    end

    def meta_tags
      @meta_tags ||= {}
    end

    def links
      @links ||= []
    end

    def tag(name, value)
      meta_tags[name] = value
    end

    def link(rel, options)
      links << {rel: rel, options: options}
    end

    def title
      @title ||= Translator.new(:titles, naming, store)
    end

    def description(html: false)
      @description[html] ||= Translator.new(:descriptions, naming, store.merge(html: html))
    end

    def keywords
      @keywords ||= Translator.new(:keywords, naming, store)
    end

    def render
      compute_default_meta_tags
      render_meta_tags + render_links
    end
    alias to_s render

    def naming
      @naming ||= Naming.new(controller)
    end

    def render_meta_tags
      meta_tags
        .map {|name, value| MetaTag.build(name, value).render }
        .join
        .html_safe
    end

    def render_links
      links
        .map {|info| Link.build(info[:rel], info[:options]).render }
        .join
        .html_safe
    end

    def compute_default_meta_tags
      DEFAULT_META_TAGS.each do |method_name|
        public_send(:"compute_default_#{method_name}")
      end
    end

    def compute_default_language
      tag(:language, I18n.locale)
    end

    def compute_default_title
      tag(:title, title) unless title.to_s.empty?
    end

    def compute_default_charset
      tag(:charset, Rails.configuration.encoding)
    end

    def compute_default_keywords
      tag(:keywords, keywords.to_s) unless keywords.to_s.empty?
    end

    def compute_default_description
      tag(:description, description.to_s) unless description.to_s.empty?
    end

    def compute_default_viewport
      tag(:viewport, "width=device-width,initial-scale=1") unless meta_tags[:viewport]
    end
  end
end
