# frozen_string_literal: true

module PageMeta
  class Action
    # rubocop:disable Style/MutableConstant
    ALIASES = {
      "update"  => "edit",
      "create"  => "new",
      "destroy" => "remove"
    }

    def initialize(action)
      @action = action
    end

    def to_s
      ALIASES[@action] || @action
    end
  end
end
