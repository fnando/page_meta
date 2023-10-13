# frozen_string_literal: true

module PageMeta
  class Naming
    def initialize(controller)
      @_controller = controller
    end

    def action
      (@action ||= Action.new(@_controller.action_name)).to_s
    end

    # Normalize the controller name.
    # Converts `PagesController` into `pages` and
    # `Admin::PagesController` into `admin.pages`.
    def controller
      @controller ||= @_controller
                      .class
                      .name
                      .underscore
                      .gsub("_controller", "")
                      .tr("/", ".")
    end
  end
end
