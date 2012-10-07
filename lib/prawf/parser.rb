# coding: utf-8
require 'json'
require 'set'
module Prawf
  class Parser
    def initialize(output)
      @output = output
      @summarized_suites = Set.new
    end

    def parse(line)
      attributes = JSON.parse(line)
      send attributes.delete('stage'), attributes
      @output.flush
    end

    private

    def before_test(attributes)
      summarize attributes['suite']
      temporary_line "* #{attributes['test']}"
    end

    def pass(attributes)
      overwrite_temporary_line "✔ #{attributes['test']}"
    end

    def failure(attributes)
      overwrite_temporary_line "✘ #{attributes['test']}"
    end

    def summarize(suite)
      return if @summarized_suites.include?(suite)
      puts suite
      puts
      @summarized_suites << suite
    end

    def temporary_line(line)
      print line
    end

    def overwrite_temporary_line(line)
      cr = "\r"
      clear = "\e[0K"
      puts cr + clear + line
    end

    def print(*args)
      @output.print *args
    end

    def puts(*args)
      @output.puts *args
    end
  end
end

