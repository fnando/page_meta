# frozen_string_literal: true

module PageMeta
  class Base
    DEFAULT_META_TAGS = %i[
      language
      charset
      title
      viewport
      keywords
      description
    ].freeze

    DEFAULT_ORDER = 99

    META_TAG_ORDER = {
      pragma: -1,
      cache_control: -1,
      expires: -1,
      refresh: -1,
      dns_prefetch_control: 4
    }.freeze

    LINK_ORDER = {
      preconnect: 6,
      preload: 7,
      modulepreload: 8,
      prefetch: 9,
      dns_prefetch: 10
    }.freeze

    attr_reader :controller, :store

    delegate :[], :[]=, to: :store

    def initialize(controller)
      @controller = controller
      @description = {}
      @store = {}
    end

    def items
      @items ||= []
    end

    # Add a new `<base>` tag.
    def base(href)
      items << {
        type: :tag,
        name: :base,
        value: {href:},
        order: 2,
        open: true
      }
    end

    # Delete all matching meta tags by name.
    def delete(name)
      items.delete_if { _1[:name] == name }
    end

    # Add a new meta tag.
    def tag(name, value = nil, order: nil, **kwargs)
      order = order || META_TAG_ORDER[name] || DEFAULT_ORDER
      items << {type: :meta, name:, value: value || kwargs, order:}
    end

    # Add a new link tag.
    def link(rel, order: nil, **options)
      order = order || LINK_ORDER[rel] || DEFAULT_ORDER
      items << {type: :link, rel:, options:, order:}
    end

    # Add new html tag, like `<base>` or `<title>`.
    def html(name, value, open: false, order: DEFAULT_ORDER)
      items << {type: :tag, name:, order:, open:, value:}
    end

    # The title translation.
    def title
      @title ||= Translator.new(:title, naming, store)
    end

    # The description translation.
    def description(html: false)
      @description[html] ||= Translator.new(
        :description,
        naming,
        store.merge(html:)
      )
    end

    # The keywords translation.
    def keywords
      @keywords ||= Translator.new(:keywords, naming, store)
    end

    def render
      compute_default_items

      items
        .sort_by { _1[:order] }
        .map { send(:"build_#{_1[:type]}", _1).render }
        .join
        .html_safe
    end
    alias to_s render

    private def build_tag(item)
      klass = item[:open] ? OpenTag : Tag

      klass.build(item[:name], item[:value])
    end

    private def build_meta(item)
      MetaTag.build(item[:name], item[:value])
    end

    private def build_link(item)
      Link.build(item[:rel], item[:options])
    end

    private def naming
      @naming ||= Naming.new(controller)
    end

    private def compute_default_items
      DEFAULT_META_TAGS.each do |method_name|
        send(:"compute_default_#{method_name}")
      end
    end

    private def compute_default_language
      tag(:language, I18n.locale)
    end

    private def compute_default_title
      return if has?(:title)
      return if title.to_s.blank?

      html(:title, title.to_s, order: 3)
      tag(:title, title)
    end

    private def compute_default_charset
      return if has?(:charset)

      tag(:charset, Rails.configuration.encoding, order: 0)
    end

    private def compute_default_keywords
      return if has?(:keywords)

      tag(:keywords, keywords.to_s) unless keywords.to_s.blank?
    end

    private def compute_default_description
      return if has?(:description)

      tag(:description, description.to_s) unless description.to_s.blank?
    end

    private def compute_default_viewport
      return if has?(:viewport)

      tag(:viewport, "width=device-width,initial-scale=1", order: 1)
    end

    private def has?(name)
      items.any? { _1[:name] == name }
    end
  end
end
