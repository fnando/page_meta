require "test_helper"

class TranslatorTest < Minitest::Test
  setup do
    reset_i18n!
  end

  test "with controller name" do
    set_translations "page_meta.titles.things.show" => "TITLE",
                     "page_meta.titles.base" => "%{value} • SITE"

    controller = build_controller("ThingsController", "show")
    naming = PageMeta::Naming.new(controller)
    translator = PageMeta::Translator.new(:titles, naming)

    assert_equal "TITLE • SITE", translator.to_s
    assert_equal "TITLE", translator.simple
  end

  test "without base translation" do
    set_translations "page_meta.titles.things.show" => "TITLE"

    controller = build_controller("ThingsController", "show")
    naming = PageMeta::Naming.new(controller)
    translator = PageMeta::Translator.new(:titles, naming)

    assert_equal "TITLE", translator.to_s
    assert_equal "TITLE", translator.simple
  end

  test "with namespaced controller" do
    set_translations "page_meta.titles.admin.things.show" => "TITLE"

    controller = build_controller("Admin::ThingsController", "show")
    naming = PageMeta::Naming.new(controller)
    translator = PageMeta::Translator.new(:titles, naming)

    assert_equal "TITLE", translator.to_s
  end

  test "with placeholders" do
    set_translations "page_meta.titles.things.show" => "%{title}"

    controller = build_controller("ThingsController", "show")
    naming = PageMeta::Naming.new(controller)
    translator = PageMeta::Translator.new(:titles, naming, title: "TITLE")

    assert_equal "TITLE", translator.to_s
  end

  test "missing translation" do
    controller = build_controller("SiteController", "contact")
    naming = PageMeta::Naming.new(controller)
    translator = PageMeta::Translator.new(:titles, naming)

    assert_equal "", translator.to_s
    assert_equal "", translator.simple
  end
end
