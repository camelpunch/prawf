# coding: utf-8
gem 'minitest'
require 'minitest/spec'
require 'minitest/reporters'

class Prawf
  class MiniTestReporter
    include MiniTest::Reporter

    def initialize(output)
      @output = output
    end

    def before_test(suite, test)
      test_name = test.sub(/^test_[0-9]+_/, '')
      @output.puts "#{suite}\n\n✓ #{test_name}"
    end
  end
end

