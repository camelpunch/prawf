# coding: utf-8
require_relative '../../spec_helper'
require_relative '../../../lib/prawf/parser'

describe Prawf::Parser do
  attr_reader :message_output, :message_input,
    :error_output, :error_input

  before do
    @message_output, @message_input = IO.pipe
    @error_output, @error_input = IO.pipe
  end

  let(:parser) { Prawf::Parser.new(message_input, error_input) }
  let(:output) { message_input.close; message_output.read }
  let(:error) { error_input.close; error_output.read }

  let(:reset) {
    cr = "\r"
    clear = "\e[0K"
    cr + clear
  }

  def parse(attributes)
    parser.parse JSON.generate(attributes)
  end

  it "copes with nil lines" do
    parser.parse nil
    output.must_equal ''
  end

  it "outputs an error when given invalid JSON" do
    parser.parse '{'
    error.must_equal <<-OUTPUT
Invalid JSON received: {
    OUTPUT
  end

  it "outputs a pass" do
    parse(stage: 'before_suites')
    parse(stage: 'before_test', suite: 'a suite', test: 'a test')
    parse(stage: 'pass', suite: 'a suite', test: 'a test')
    parse(stage: 'after_suites')
    output.must_equal <<-OUTPUT
a suite

* a test#{reset}#{ANSI.green { "✔" }} a test
    OUTPUT
  end

  it "outputs a failure" do
    parse(stage: 'before_suites')
    parse(stage: 'before_test', suite: 'flaky suite', test: 'a failed test')
    parse(stage: 'failure', suite: 'flaky suite', test: 'a failed test')
    parse(stage: 'after_suites')
    output.must_equal <<-OUTPUT
flaky suite

* a failed test#{reset}#{ANSI.red { "✘" }} a failed test
    OUTPUT
  end

  it "outputs a failure after a pass" do
    parse(stage: 'before_suites')
    parse(stage: 'before_test', suite: 'flaky suite', test: 'a passing test')
    parse(stage: 'pass', suite: 'flaky suite', test: 'a passing test')
    parse(stage: 'before_test', suite: 'flaky suite', test: 'a failed test')
    parse(stage: 'failure', suite: 'flaky suite', test: 'a failed test')
    parse(stage: 'after_suites')
    output.must_equal <<-OUTPUT
flaky suite

* a passing test#{reset}#{ANSI.green { "✔" }} a passing test
* a failed test#{reset}#{ANSI.red { "✘" }} a failed test
    OUTPUT
  end

  it "has the same output for subsequent test runs" do
    2.times do
      parse(stage: 'before_suites')
      parse(stage: 'before_test', suite: 'repeated suite', test: 'a pass')
      parse(stage: 'pass', suite: 'repeated suite', test: 'a pass')
      parse(stage: 'before_test', suite: 'repeated suite', test: 'a fail')
      parse(stage: 'failure', suite: 'repeated suite', test: 'a fail')
      parse(stage: 'after_suites')
    end
    output.must_equal <<-OUTPUT
repeated suite

* a pass#{reset}#{ANSI.green { "✔" }} a pass
* a fail#{reset}#{ANSI.red { "✘" }} a fail

repeated suite

* a pass#{reset}#{ANSI.green { "✔" }} a pass
* a fail#{reset}#{ANSI.red { "✘" }} a fail
    OUTPUT
  end

  it "separates suites with newlines" do
    parse(stage: 'before_suites')
    parse(stage: 'before_test', suite: 'first suite', test: 'a pass')
    parse(stage: 'pass', suite: 'repeated suite', test: 'a pass')
    parse(stage: 'after_suites')

    parse(stage: 'before_suites')
    parse(stage: 'before_test', suite: 'second suite', test: 'a pass')
    parse(stage: 'pass', suite: 'repeated suite', test: 'a pass')
    parse(stage: 'after_suites')

    output.must_equal <<-OUTPUT
first suite

* a pass#{reset}#{ANSI.green { "✔" }} a pass

second suite

* a pass#{reset}#{ANSI.green { "✔" }} a pass
    OUTPUT
  end
end
