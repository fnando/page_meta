module PageMeta
  module Helpers
    def page_meta
      @page_meta ||= PageMeta::Base.new(self)
    end
  end
end
