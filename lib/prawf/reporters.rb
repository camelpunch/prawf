# coding: utf-8
gem 'minitest'
require 'minitest/spec'
require 'minitest/reporters'
require 'json'

module Prawf
  class MiniTestReporter
    include MiniTest::Reporter

    def initialize(output)
      @output = output
    end

    def before_test(suite_name, test_name)
      report 'before_test', suite_name, test_name
    end

    def pass(suite_name, test_name, test_runner)
      report 'pass', suite_name, test_name
    end

    def failure(suite_name, test_name, test_runner)
      report 'failure', suite_name, test_name
    end

    private

    def report(event, suite_name, test_name)
      @output.puts JSON.generate(
        stage: event,
        suite: suite_name,
        test: test_name.sub(/^test_[0-9]+_/, '')
      )
    end
  end
end

