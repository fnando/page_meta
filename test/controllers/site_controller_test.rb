# frozen_string_literal: true

require "test_helper"

module SiteControllerTest
  class NewFormatTest < ActionController::TestCase
    tests SiteController

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

    test "render html description as a paragraph" do
      get :home

      assert_select ".description" do |node|
        assert_equal "The <strong>best way</strong> of doing something",
                     node.first.inner_html
      end
    end

    test "defaults description to the text version when html is not available" do
      get :about

      assert_select ".description" do |node|
        assert_equal "This is about something", node.first.inner_html
      end
    end
  end

  class OldFormatTest < ActionController::TestCase
    tests SiteController

    setup do
      @routes = Rails.application.routes
      reset_i18n!(Dir["./test/support/config/locales_old_format/**/*.yml"])
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

    test "render html description as a paragraph" do
      get :home

      assert_select ".description" do |node|
        assert_equal "The <strong>best way</strong> of doing something",
                     node.first.inner_html
      end
    end

    test "defaults description to the text version when html is not available" do
      get :about

      assert_select ".description" do |node|
        assert_equal "This is about something", node.first.inner_html
      end
    end
  end
end
