# coding: utf-8
gem 'minitest'
require 'minitest/spec'
require 'minitest/reporters'
require 'json'

class Prawf
  class MiniTestReporter
    include MiniTest::Reporter

    def initialize(output)
      @output = output
    end

    def before_test(suite_name, test_name)
      @output.puts JSON.generate(
        stage: 'before_test',
        suite: suite_name,
        test: test_name.sub(/^test_[0-9]+_/, '')
      )
    end
  end
end

