# frozen_string_literal: true

module PageMeta
  class Tag
    def self.build(tag, content)
      new(tag, content)
    end

    attr_reader :tag, :content

    def initialize(tag, content)
      @tag = tag
      @content = content
    end

    def render
      helpers.content_tag(tag, content) unless content.blank?
    end

    def helpers
      ActionController::Base.helpers
    end
  end
end
