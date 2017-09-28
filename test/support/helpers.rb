# frozen_string_literal: true

module Helpers
  # rubocop:disable Lint/UnusedMethodArgument
  def build_controller(class_name, action_name)
    instance_eval <<-RUBY
      klass = Class.new do
        attr_reader :action_name

        def self.name
          #{class_name.to_s.inspect}
        end

        def initialize(action_name)
          @action_name = action_name
        end
      end

      klass.new(action_name)
    RUBY
  end

  def translations(scopes)
    translations = {}

    scopes.each do |scope, value|
      *parts, last_scope = scope.split(".")
      context = translations

      while parts.any?
        scope_name = parts.shift
        context[scope_name] ||= {}
        context = context[scope_name]
      end

      context[last_scope] = value
    end

    I18n.backend.store_translations :en, translations
  end

  def reset_i18n!(load_path = [])
    I18n.load_path = load_path
    I18n.available_locales = [:en]
    I18n.reload!
    I18n.backend.send :init_translations
  end
end

Minitest::Test.include Helpers
