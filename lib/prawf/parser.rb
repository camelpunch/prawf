# coding: utf-8
require 'json'
module Prawf
  class Parser
    def initialize(output)
      @output = output
    end

    def parse(line)
      attributes = JSON.parse(line)

      @output.puts attributes['suite']
      @output.puts
      @output.puts "✔ #{attributes['test']}"
      @output.flush
    end
  end
end

