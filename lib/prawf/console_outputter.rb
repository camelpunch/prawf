# coding: utf-8
module Prawf
  class ConsoleOutputter
    def initialize(output, error_output)
      @output = output
      @error = error_output
    end

    def before_suite(suite)
      @output.puts "#{suite.name}\n\n"
    end

    def before_test(test)
      @output.print status_of(test => asterisk)
    end

    def pass(test)
      @output.puts status_of(test => [reset, check])
    end

    def fail(test)
      @output.puts status_of(test => [reset, cross])
    end

    def error(text)
      @error.puts text
    end

    private

    def status_of(options)
      test = options.keys.first
      prepend = options.values.join
      [prepend, test.name].join(' ')
    end

    def reset
      [cr, clear].join
    end

    def cr; "\r"; end
    def clear; "\e[0K"; end
    def asterisk; '*'; end
    def check; ANSI.green { "✔" }; end
    def cross; ANSI.red { "✘" }; end
  end
end
