# frozen_string_literal: true

require "test_helper"

class SiteControllerTest < ActionController::TestCase
  setup do
    @routes = Rails.application.routes
    reset_i18n!(Dir["./test/support/config/locales/**/*.yml"])
  end

  test "render title for simple controller" do
    get :home
    assert_select "title", "Welcome • Dummy"
  end

  test "render description for simple controller" do
    get :home

    assert_select "meta[name=description]" do |node|
      assert_equal "The best way of doing something", node.first[:content]
    end
  end

  test "render keywords for simple controller" do
    get :home

    assert_select "meta[name=keywords]" do |node|
      assert_equal "mysite, saas", node.first[:content]
    end
  end
end
