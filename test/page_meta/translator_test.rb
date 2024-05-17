# frozen_string_literal: true

require "test_helper"

class TranslatorTest < Minitest::Test
  setup do
    reset_i18n!
  end

  test "with controller name" do
    translations "page_meta.titles.things.show" => "TITLE",
                 "page_meta.titles.base" => "%{value} • SITE"

    controller = build_controller("ThingsController", "show")
    naming = PageMeta::Naming.new(controller)
    translator = PageMeta::Translator.new(:titles, naming)

    assert_equal "TITLE • SITE", translator.to_s
    assert_equal "TITLE", translator.simple
  end

  test "without base translation" do
    translations "page_meta.titles.things.show" => "TITLE"

    controller = build_controller("ThingsController", "show")
    naming = PageMeta::Naming.new(controller)
    translator = PageMeta::Translator.new(:titles, naming)

    assert_equal "TITLE", translator.to_s
    assert_equal "TITLE", translator.simple
  end

  test "with namespaced controller" do
    translations "page_meta.titles.admin.things.show" => "TITLE"

    controller = build_controller("Admin::ThingsController", "show")
    naming = PageMeta::Naming.new(controller)
    translator = PageMeta::Translator.new(:titles, naming)

    assert_equal "TITLE", translator.to_s
  end

  test "with placeholders" do
    translations "page_meta.titles.things.show" => "%{title}"

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

  test "returns html translation" do
    translations(
      "page_meta.descriptions.site.home_html" => "<strong>DESCRIPTION</strong>"
    )

    controller = build_controller("SiteController", "home")
    naming = PageMeta::Naming.new(controller)
    translator = PageMeta::Translator.new(:descriptions, naming, html: true)

    assert_equal "<strong>DESCRIPTION</strong>", translator.to_s
  end

  test "with grouped translations" do
    translations "page_meta.things.show" => {
      description: "DESCRIPTION",
      title: "TITLE"
    }

    controller = build_controller("ThingsController", "show")
    naming = PageMeta::Naming.new(controller)
    title_translator = PageMeta::Translator.new(:titles, naming)
    description_translator = PageMeta::Translator.new(:descriptions, naming)

    assert_equal "TITLE", title_translator.to_s
    assert_equal "TITLE", title_translator.simple
    assert_equal "DESCRIPTION", description_translator.simple
  end

  test "with grouped translations using a new base translation" do
    translations "page_meta.things.show" => {title: "TITLE"},
                 "page_meta.title_base" => "%{value} • SITE"

    controller = build_controller("ThingsController", "show")
    naming = PageMeta::Naming.new(controller)
    title_translator = PageMeta::Translator.new(:titles, naming)

    assert_equal "TITLE • SITE", title_translator.to_s
    assert_equal "TITLE", title_translator.simple
  end
end
