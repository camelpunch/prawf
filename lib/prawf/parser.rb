# coding: utf-8
require 'json'
require 'set'
require 'ansi/code'
require_relative 'test'
require_relative 'suite'

module Prawf
  class Parser
    def initialize(outputter)
      @outputter = outputter
    end

    def parse(line)
      attributes = JSON.parse(line)
    rescue JSON::ParserError
      @outputter.error("Invalid JSON received: #{line}")
    rescue TypeError
    else
      stage = attributes['stage']
      if stage
        send stage, attributes
      else
        @outputter.error "Invalid instruction received: #{line}"
      end
    end

    private

    def before_suites(*)
    end

    def after_suites(*)
    end

    def before_suite(attributes)
      @current_suite = Suite.new(attributes['suite'])
      @outputter.before_suite(@current_suite)
    end

    def before_test(attributes)
      @current_test = Test.new(attributes['test'], @current_suite)
      @outputter.before_test(@current_test)
    end

    def pass(attributes)
      @outputter.pass(@current_test)
    end

    def failure(attributes)
      @outputter.fail(@current_test)
    end
  end
end

