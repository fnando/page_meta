# frozen_string_literal: true

ENV["RAILS_ENV"] = "test"

require "rails"
require "action_controller/railtie"

Bundler.require :default, :test

module Dummy
  class Application < Rails::Application
    config.eager_load = false
    config.active_support.test_order = :random
    config.secret_key_base = SecureRandom.hex(100)
    config.i18n.load_path += Dir["#{__dir__}/config/locales/**/*.yml"]
    config.load_defaults Rails.version[0..1].to_f
  end
end

Rails.application.initialize!

Rails.application.routes.draw do
  root to: "site#home"
  get "about", to: "site#about"
  get "page", to: "pages#show"
  get "article", to: "pages#article"
end

class ApplicationController < ActionController::Base
  prepend_view_path "#{__dir__}/app/views"
end

class SiteController < ApplicationController
  def home
  end

  def about
  end
end

class PagesController < ApplicationController
  def show
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

    page_meta.link :last, href: "/pages/last"
    page_meta.link :first, href: "/pages/first"
    page_meta.link :next, href: "/pages/next"
    page_meta.link :previous, href: "/pages/previous"
    page_meta.link :fluid_icon, type: "image/png", href: "fluid.icon"

    page_meta.link :apple_touch_icon, sizes: "512x512", href: "/launcher-512.png"
    page_meta.link :apple_touch_icon, sizes: "1024x1024", href: "/launcher-1024.png"
  end

  def article
    page_meta[:title] = "Dynamic Title"
  end
end
