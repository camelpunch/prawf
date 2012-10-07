# coding: utf-8
require 'json'
require 'set'
module Prawf
  class Parser
    def initialize(output)
      @output = output
    end

    def parse(line)
      attributes = JSON.parse(line)
      event = attributes.delete 'stage'
      send event, attributes
      @output.flush
    end

    private

    def suites
      @suites ||= Set.new
    end

    def before_test(attributes)
      unless suites.include?(attributes['suite'])
        @output.puts attributes['suite']
        @output.puts
        suites << attributes['suite']
      end
    end

    def pass(attributes)
      @output.puts "✔ #{attributes['test']}"
    end

    def failure(attributes)
      @output.puts "✘ #{attributes['test']}"
    end
  end
end

