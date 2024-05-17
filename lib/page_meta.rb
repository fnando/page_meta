# frozen_string_literal: true

module PageMeta
  require "i18n"
  require "rails/railtie"

  require "page_meta/version"
  require "page_meta/base"
  require "page_meta/meta_tag"
  require "page_meta/hash_meta_tag"
  require "page_meta/meta_tag/charset"
  require "page_meta/meta_tag/dns_prefetch_control"
  require "page_meta/meta_tag/title"
  require "page_meta/meta_tag/language"
  require "page_meta/meta_tag/og"
  require "page_meta/meta_tag/twitter"
  require "page_meta/link"
  require "page_meta/helpers"
  require "page_meta/tag"
  require "page_meta/open_tag"
  require "page_meta/action"
  require "page_meta/naming"
  require "page_meta/translator"
  require "page_meta/railtie"
end
