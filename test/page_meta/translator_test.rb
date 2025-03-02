# frozen_string_literal: true

require "test_helper"

class TranslatorTest < Minitest::Test
  setup do
    reset_i18n!
  end

  test "with controller name" do
    translations "page_meta.things.show.title" => "TITLE",
                 "page_meta.title_base" => "%{value} • SITE"

    controller = build_controller("ThingsController", "show")
    naming = PageMeta::Naming.new(controller)
    translator = PageMeta::Translator.new(:title, naming)

    assert_equal "TITLE • SITE", translator.to_s
    assert_equal "TITLE", translator.simple
  end

  test "without base translation" do
    translations "page_meta.things.show.title" => "TITLE"

    controller = build_controller("ThingsController", "show")
    naming = PageMeta::Naming.new(controller)
    translator = PageMeta::Translator.new(:title, naming)

    assert_equal "TITLE", translator.to_s
    assert_equal "TITLE", translator.simple
  end

  test "with namespaced controller" do
    translations "page_meta.admin.things.show.title" => "TITLE"

    controller = build_controller("Admin::ThingsController", "show")
    naming = PageMeta::Naming.new(controller)
    translator = PageMeta::Translator.new(:title, naming)

    assert_equal "TITLE", translator.to_s
  end

  test "with placeholders" do
    translations "page_meta.things.show.title" => "%{title}"

    controller = build_controller("ThingsController", "show")
    naming = PageMeta::Naming.new(controller)
    translator = PageMeta::Translator.new(:title, naming, title: "TITLE")

    assert_equal "TITLE", translator.to_s
  end

  test "missing translation" do
    controller = build_controller("SiteController", "contact")
    naming = PageMeta::Naming.new(controller)
    translator = PageMeta::Translator.new(:title, naming)

    assert_equal "", translator.to_s
    assert_equal "", translator.simple
  end

  test "returns html translation" do
    translations(
      "page_meta.site.home.description_html" => "<strong>DESCRIPTION</strong>"
    )

    controller = build_controller("SiteController", "home")
    naming = PageMeta::Naming.new(controller)
    translator = PageMeta::Translator.new(:description, naming, html: true)

    assert_equal "<strong>DESCRIPTION</strong>", translator.to_s
  end

  test "with grouped translations" do
    translations "page_meta.things.show" => {
      description: "DESCRIPTION",
      title: "TITLE"
    }

    controller = build_controller("ThingsController", "show")
    naming = PageMeta::Naming.new(controller)
    title_translator = PageMeta::Translator.new(:title, naming)
    description_translator = PageMeta::Translator.new(:description, naming)

    assert_equal "TITLE", title_translator.to_s
    assert_equal "TITLE", title_translator.simple
    assert_equal "DESCRIPTION", description_translator.simple
  end

  test "with grouped translations using a new base translation" do
    translations "page_meta.things.show" => {title: "TITLE"},
                 "page_meta.title_base" => "%{value} • SITE"

    controller = build_controller("ThingsController", "show")
    naming = PageMeta::Naming.new(controller)
    title_translator = PageMeta::Translator.new(:title, naming)

    assert_equal "TITLE • SITE", title_translator.to_s
    assert_equal "TITLE", title_translator.simple
  end

  test "with base placeholders" do
    translations "page_meta.things.show.title" => "TITLE",
                 "page_meta.title_base" => "%{value} • %{site_name}"

    controller = build_controller("ThingsController", "show")
    naming = PageMeta::Naming.new(controller)
    options = {site_name: "SOME SITE"}
    translator = PageMeta::Translator.new(:title, naming, options)

    assert_equal "TITLE • SOME SITE", translator.to_s
    assert_equal "TITLE", translator.simple
  end

  test "with custom base title for action" do
    translations "page_meta.things.show.title" => "TITLE",
                 "page_meta.things.show.title_base" => "%{value} | %{site_name}"

    controller = build_controller("ThingsController", "show")
    naming = PageMeta::Naming.new(controller)
    options = {site_name: "SOME SITE"}
    translator = PageMeta::Translator.new(:title, naming, options)

    assert_equal "TITLE | SOME SITE", translator.to_s
    assert_equal "TITLE", translator.simple
  end

  test "with custom base title for controller" do
    translations "page_meta.things.show.title" => "TITLE",
                 "page_meta.things.title_base" => "%{value} | %{site_name}"

    controller = build_controller("ThingsController", "show")
    naming = PageMeta::Naming.new(controller)
    options = {site_name: "SOME SITE"}
    translator = PageMeta::Translator.new(:title, naming, options)

    assert_equal "TITLE | SOME SITE", translator.to_s
    assert_equal "TITLE", translator.simple
  end
end
