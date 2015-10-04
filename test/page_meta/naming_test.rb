require "test_helper"

class NamingTest < Minitest::Test
  test "set class name" do
    controller = build_controller("Admin::PagesController", "show")
    assert_equal "Admin::PagesController", controller.class.name
  end

  test "set action name" do
    controller = build_controller("Admin::PagesController", "show")
    assert_equal "show", controller.action_name
  end

  test "return simple controller name" do
    controller = build_controller("PagesController", "show")
    naming = PageMeta::Naming.new(controller)

    assert_equal "pages", naming.controller
  end

  test "return namespaced controller name" do
    controller = build_controller("Admin::PagesController", "show")
    naming = PageMeta::Naming.new(controller)

    assert_equal "admin.pages", naming.controller
  end

  test "return action name" do
    controller = build_controller("Pages", "show")
    naming = PageMeta::Naming.new(controller)

    assert_equal "show", naming.action
  end
end
