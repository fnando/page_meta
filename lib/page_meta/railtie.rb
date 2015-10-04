module PageMeta
  class Railtie < Rails::Railtie
    initializer "page_meta" do
      ActionController::Base.include Helpers
      ActionController::Base.helper_method :page_meta
    end
  end
end
