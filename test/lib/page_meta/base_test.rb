# frozen_string_literal: true

require "test_helper"

class BaseTest < Minitest::Test
  test "deletes item by name" do
    I18n.load_path += Dir["./test/support/config/locales/*.yml"]
    I18n.eager_load!

    controller = PagesController.new
    controller.action_name = "show"
    page_meta = PageMeta::Base.new(controller)

    page_meta.base "http://example.com/"
    page_meta.tag :author, "John Doe"

    assert_equal 2, page_meta.items.size

    page_meta.delete :base
    page_meta.delete :author

    assert_equal 0, page_meta.items.size
  end

  test "renders most important tags first" do
    I18n.load_path += Dir["./test/support/config/locales/*.yml"]
    I18n.eager_load!

    controller = PagesController.new
    controller.action_name = "show"
    page_meta = PageMeta::Base.new(controller)

    page_meta.base "http://example.com/"
    page_meta.tag :author, "John Doe"
    page_meta.tag :robots, "index, follow"
    page_meta.tag :copyright, "ACME"
    page_meta.tag :pragma, "no-cache"
    page_meta.tag :description, "DESCRIPTION"
    page_meta.tag :dns_prefetch_control, "http://example.com"
    page_meta.tag :keywords, "KEYWORDS"

    page_meta.tag :og,
                  image: "IMAGE",
                  image_type: "image/jpeg",
                  image_width: 800,
                  image_height: 600,
                  description: "DESCRIPTION",
                  title: "TITLE",
                  type: "article",
                  article_author: "John Doe",
                  article_section: "Getting Started",
                  url: "URL"

    page_meta.tag :twitter,
                  card: "summary",
                  site: "@johndoe",
                  domain: "DOMAIN",
                  image: "IMAGE",
                  creator: "@marydoe"

    page_meta.link :preconnect, href: "http://assets.example.com/"
    page_meta.link :preload, href: "style.css", as: "style"
    page_meta.link :modulepreload, href: "main.js"
    page_meta.link :prefetch, href: "main.js"
    page_meta.link :last, href: "/pages/last"
    page_meta.link :first, href: "/pages/first"
    page_meta.link :next, href: "/pages/next"
    page_meta.link :previous, href: "/pages/previous"
    page_meta.link :fluid_icon, type: "image/png", href: "fluid.icon"

    page_meta.link :apple_touch_icon,
                   sizes: "512x512",
                   href: "/launcher-512.png"
    page_meta.link :apple_touch_icon,
                   sizes: "1024x1024",
                   href: "/launcher-1024.png"

    page_meta.items.shuffle!

    html = Nokogiri::HTML.fragment(page_meta.render)

    expected = %[<meta http-equiv="pragma" content="no-cache">]
    assert_equal expected, html.children[0].to_s

    expected = %[<meta charset="UTF-8">]
    assert_equal expected, html.children[1].to_s

    expected =
      %[<meta name="viewport" content="width=device-width,initial-scale=1">]
    assert_equal expected, html.children[2].to_s

    expected = %[<base href="http://example.com/">]
    assert_equal expected, html.children[3].to_s

    expected = %[<title>Show Page • Dummy</title>]
    assert_equal expected, html.children[4].to_s

    expected = %[<meta http-equiv="x-dns-prefetch-control" content="on">] +
               %[<link rel="dns-prefetch" href="http://example.com">]
    assert_equal expected, html.children[5..6].to_s

    expected = %[<link href="http://assets.example.com/" rel="preconnect">]
    assert_equal expected, html.children[7].to_s

    expected = %[<link href="style.css" as="style" rel="preload">]
    assert_equal expected, html.children[8].to_s

    expected = %[<link href="main.js" rel="modulepreload">]
    assert_equal expected, html.children[9].to_s

    expected = %[<link href="main.js" rel="prefetch">]
    assert_equal expected, html.children[10].to_s
  end
end
