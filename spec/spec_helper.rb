gem 'minitest'
require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/reporters'
require_relative '../lib/prawf/reporters'
require 'debugger'

MiniTest::Reporters.use! [
  MiniTest::Reporters::SpecReporter.new,
  #Prawf::MiniTestReporter.new(File.open('/tmp/prawfpipe2', 'w'))
]

