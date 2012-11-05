# coding: utf-8
gem 'minitest'
require 'minitest/spec'
require 'minitest/reporter'
require 'json'

module Prawf
  class MiniTestReporter
    include MiniTest::Reporter

    def initialize(output)
      @output = output
    end

    def before_suite(*args)
      report 'before_suite', *args
    end

    def before_test(*args)
      report 'before_test', *args
    end

    def pass(*args)
      report 'pass', *args[0..1]
    end

    def failure(suite_name, test_name, test_runner)
      report 'failure', suite_name, test_name,
        test_runner.exception.message,
        test_runner.exception.backtrace
    end

    def before_suites(*)
      report 'before_suites'
    end

    def after_suites(*)
      report 'after_suites'
    end

    private

    def report(event, suite_name = nil, test_name = nil, message = nil,
               backtrace = nil)
      data = { stage: event }
      data[:suite] = suite_name if suite_name
      data[:test] = test_name.sub(/^test_[0-9]+_/, '') if test_name
      data[:message] = message if message
      data[:backtrace] = MiniTest.filter_backtrace(backtrace) if backtrace
      @output.puts JSON.generate(data)
      @output.flush
    end
  end
end

