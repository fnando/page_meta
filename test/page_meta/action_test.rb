# frozen_string_literal: true

require "test_helper"

class ActionTest < Minitest::Test
  test "map default alias - update" do
    action = PageMeta::Action.new("update")
    assert_equal "edit", action.to_s
  end

  test "map default alias - create" do
    action = PageMeta::Action.new("create")
    assert_equal "new", action.to_s
  end

  test "map default alias - destroy" do
    action = PageMeta::Action.new("destroy")
    assert_equal "remove", action.to_s
  end

  test "define new alias" do
    PageMeta::Action::ALIASES["landing"] = "home"
    action = PageMeta::Action.new("landing")
    assert_equal "home", action.to_s
    PageMeta::Action::ALIASES.delete("landing")
  end
end
