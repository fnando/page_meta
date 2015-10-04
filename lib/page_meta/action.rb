module PageMeta
  class Action
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
