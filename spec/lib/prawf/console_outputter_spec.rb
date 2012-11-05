# coding: utf-8
require_relative '../../spec_helper'
require_relative '../../../lib/prawf/test'
require_relative '../../../lib/prawf/suite'
require_relative '../../../lib/prawf/console_outputter'

module Prawf
  describe ConsoleOutputter do
    let(:unused_suite) {
      Suite.new('unused suite')
    }

    let(:reset) {
      cr = "\r"
      clear = "\e[0K"
      cr + clear
    }

    before do
      @message_output, @message_input = IO.pipe
      @error_output, @error_input = IO.pipe
    end

    let(:outputter) { ConsoleOutputter.new(@message_input, @error_input) }
    let(:output) { @message_input.close; @message_output.read }
    let(:error) { @error_input.close; @error_output.read }

    it "can send errors to the error output" do
      outputter.error('Oh no!')
      error.must_equal "Oh no!\n"
    end

    it "shows the suite name when it is received" do
      suite = Suite.new('A Suite of Mine')
      outputter.before_suite(suite)
      output.must_equal "A Suite of Mine\n\n"
    end

    it "shows an asterisk next to the description when test is received" do
      test = Test.new('asterisk test', unused_suite)
      outputter.before_test(test)
      output.must_equal "* asterisk test"
    end

    it "shows a green check mark next to the description when a test passes" do
      test = Test.new('my test', unused_suite)
      outputter.before_test(test)
      outputter.pass(test)
      output.must_equal "* my test#{reset}#{ANSI.green { "✔" }} my test\n"
    end

    it "shows a red X next to the description when a test fails" do
      test = Test.new('failing test', unused_suite)
      outputter.before_test(test)
      outputter.fail(test, "went totally\nwrong!", backtrace = [])
      output.must_equal <<-OUTPUT
* failing test#{reset}#{ANSI.red { "✘" }} failing test
  went totally
  wrong!


      OUTPUT
    end

    it "shows backtraces" do
      test = Test.new('failing test', unused_suite)
      outputter.before_test(test)
      outputter.fail(test, "went totally\nwrong!",
                     ['some backtrace', 'for you'])
      output.must_equal <<-OUTPUT
* failing test#{reset}#{ANSI.red { "✘" }} failing test
  went totally
  wrong!
  some backtrace
  for you

      OUTPUT
    end
  end
end
