# frozen_string_literal: true

require "test_helper"

class PagesControllerTest < ActionController::TestCase
  setup do
    @routes = Rails.application.routes
    reset_i18n!(Dir["./test/support/config/locales/**/*.yml"])
  end

  test "render encoding tag" do
    get :show
    assert_select "meta[charset=UTF-8]"
  end

  test "render language tag" do
    get :show
    assert_select "meta[name=language][content=en]"
  end

  test "render author tag" do
    get :show
    assert_select "meta[name=author][content='John Doe']"
    assert_select "meta[itemprop=author][content='John Doe']"
  end

  test "render description tag" do
    get :show
    assert_select "meta[name=description][content=DESCRIPTION]"
    assert_select "meta[itemprop=description][content=DESCRIPTION]"
  end

  test "render keywords tag" do
    get :show
    assert_select "meta[name=keywords][content=KEYWORDS]"
    assert_select "meta[itemprop=keywords][content=KEYWORDS]"
  end

  test "render robots tag" do
    get :show
    assert_select "meta[name=robots][content='index, follow']"
  end

  test "render copyright tag" do
    get :show
    assert_select "meta[name=copyright][content='ACME']"
  end

  test "render dns prefetch tag" do
    get :show

    assert_select "meta[http-equiv=x-dns-prefetch-control][content=on]"
    assert_select "link[rel=dns-prefetch][href='http://example.com']"
  end

  test "render title" do
    get :show

    assert_select "title", "Show Page • Dummy"
    assert_select "meta[name='DC.title'][content='Show Page']"
    assert_select "meta[itemprop=name][content='Show Page']"
  end

  test "render links" do
    get :show

    assert_select "link[rel=last][href='/pages/last']"
    assert_select "link[rel=first][href='/pages/first']"
    assert_select "link[rel=next][href='/pages/next']"
    assert_select "link[rel=previous][href='/pages/previous']"
  end

  test "render og" do
    get :show

    assert_select "meta[property='og:type'][content=article]"
    assert_select "meta[property='og:image'][content=IMAGE]"
    assert_select "meta[property='og:image:type'][content='image/jpeg']"
    assert_select "meta[property='og:image:width'][content='800']"
    assert_select "meta[property='og:image:height'][content='600']"
    assert_select "meta[property='og:description'][content=DESCRIPTION]"
    assert_select "meta[property='og:title'][content='TITLE']"
    assert_select "meta[property='og:type'][content=article]"
    assert_select "meta[property='og:article:author'][content='John Doe']"
    assert_select "meta[property='og:article:section'][content='Getting Started']"
    assert_select "meta[property='og:url'][content='URL']"
  end

  test "render twitter" do
    get :show

    assert_select "meta[property='twitter:card'][content=summary]"
    assert_select "meta[property='twitter:site'][content='@johndoe']"
    assert_select "meta[property='twitter:domain'][content='DOMAIN']"
    assert_select "meta[property='twitter:image'][content='IMAGE']"
    assert_select "meta[property='twitter:creator'][content='@marydoe']"
  end

  test "render title with placeholder" do
    get :article
    assert_select "title", "Dynamic Title • Dummy"
  end

  test "render fluid icon tag" do
    get :show
    assert_select "link[rel='fluid-icon'][type='image/png'][href='fluid.icon']"
  end

  test "render multiple tags with same rel" do
    get :show
    assert_select "link[rel='apple-touch-icon'][sizes='512x512'][href='/launcher-512.png']"
    assert_select "link[rel='apple-touch-icon'][sizes='1024x1024'][href='/launcher-1024.png']"
  end
end
