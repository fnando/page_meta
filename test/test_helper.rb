# frozen_string_literal: true

require "simplecov"
SimpleCov.start

require "bundler/setup"
require "minitest/autorun"
require "minitest/utils"

require "ostruct"
require_relative "support/helpers"
require_relative "support/dummy"

require "page_meta"
