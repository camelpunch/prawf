# coding: utf-8
gem 'minitest'
require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/reporters'

class Prawf
  class MiniTestReporter
    include MiniTest::Reporter

    def initialize(pipe_path)
      @pipe = File.open(pipe_path, 'w')
    end

    def before_test(suite, test)
      test_name = test.sub(/^test_[0-9]+_/, '')
      @pipe.puts "#{suite}\n\n✓ #{test_name}"
    end
  end
end

MiniTest::Reporters.use! Prawf::MiniTestReporter.new('/tmp/prawfpipe')

describe "My Class" do
  it "is awesome" do
    true.must_equal true
  end
end
