# frozen_string_literal: true

module PageMeta
  class OpenTag
    def self.build(tag, attrs)
      new(tag, attrs)
    end

    attr_reader :tag, :attrs

    def initialize(tag, attrs)
      @tag = tag
      @attrs = attrs
    end

    def render
      helpers.tag(tag, attrs)
    end

    def helpers
      ActionController::Base.helpers
    end
  end
end
