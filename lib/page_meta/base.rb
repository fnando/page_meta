module PageMeta
  class Base
    attr_reader :controller, :store

    delegate :[], :[]=, to: :store

    def initialize(controller)
      @controller = controller
      @store = {}
    end

    def meta_tags
      @meta_tags ||= {}
    end

    def links
      @links ||= {}
    end

    def tag(name, value)
      meta_tags[name] = value
    end

    def link(name, value)
      links[name] = value
    end

    def title
      @title ||= Translator.new(:titles, naming, store)
    end

    def description
      @description ||= Translator.new(:descriptions, naming, store)
    end

    def keywords
      @keywords ||= Translator.new(:keywords, naming, store)
    end

    def render
      compute_default_meta_tags
      render_meta_tags + render_links
    end
    alias_method :to_s, :render

    def naming
      @naming ||= Naming.new(controller)
    end

    def render_meta_tags
      meta_tags
        .map {|name, value| MetaTag.build(name, value).render }
        .join("")
        .html_safe
    end

    def render_links
      links
        .map {|rel, options| Link.build(rel, options).render }
        .join("")
        .html_safe
    end

    def compute_default_meta_tags
      tag(:language, I18n.locale)
      tag(:charset, Rails.configuration.encoding)
      tag(:title, title) unless title.to_s.empty?
      tag(:keywords, keywords.to_s) unless keywords.to_s.empty?
      tag(:description, description.to_s) unless description.to_s.empty?
    end
  end
end
