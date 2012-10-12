# coding: utf-8
require 'json'
require 'set'
require 'ansi/code'
require_relative 'parsed_line'

module Prawf
  class Parser
    def initialize(output, error_output)
      @first_run = true
      @output = output
      @error_output = error_output
      @summarized_suites = Set.new
    end

    def parse(line)
      parsed_line = ParsedLine.new(line)
      send parsed_line.stage, parsed_line.attributes
      @output.flush
    rescue ParsedLine::ParseError => e
      @error_output.puts message
      @error_output.flush
    end

    private

    def before_test(attributes)
      summarize attributes['suite']
      temporary_line "* #{attributes['test']}"
    end

    def pass(attributes)
      overwrite_temporary_line "#{ANSI.green { "✔" }} #{attributes['test']}"
    end

    def failure(attributes)
      overwrite_temporary_line "#{ANSI.red { "✘" }} #{attributes['test']}"
    end

    def before_suites(*)
      puts unless @first_run
    end

    def after_suites(*)
      @first_run = false
      @summarized_suites.clear
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

