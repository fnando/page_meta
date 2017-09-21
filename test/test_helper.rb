require 'simplecov'
SimpleCov.start

require "bundler/setup"
require "test_notifier"
require "minitest/autorun"
require "minitest/utils"

require "ostruct"
require_relative "./support/helpers"
require_relative "./support/dummy"

require "page_meta"
