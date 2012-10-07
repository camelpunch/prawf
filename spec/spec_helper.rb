gem 'minitest'
require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/reporters'
require 'debugger'

MiniTest::Reporters.use! MiniTest::Reporters::SpecReporter.new

