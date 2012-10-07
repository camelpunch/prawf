# coding: utf-8
require_relative '../../spec_helper'
require_relative '../../../lib/prawf/parser'

describe Prawf::Parser do
  attr_reader :pipe_output, :pipe_input

  before do
    @pipe_output, @pipe_input = IO.pipe
  end

  let(:parser) { Prawf::Parser.new(pipe_input) }
  let(:output) { pipe_input.close; pipe_output.read }

  let(:reset) {
    cr = "\r"
    clear = "\e[0K"
    cr + clear
  }

  def parse(attributes)
    parser.parse JSON.generate(attributes)
  end

  it "outputs a pass" do
    parse(stage: 'before_test',
          suite: 'a suite',
          test: 'a test')
    parse(stage: 'pass',
          suite: 'a suite',
          test: 'a test')
    output.must_equal <<-OUTPUT
a suite

* a test#{reset}✔ a test
    OUTPUT
  end

  it "outputs a failure" do
    parse(stage: 'before_test',
          suite: 'flaky suite',
          test: 'a failed test')
    parse(stage: 'failure',
          suite: 'flaky suite',
          test: 'a failed test')
    output.must_equal <<-OUTPUT
flaky suite

* a failed test#{reset}✘ a failed test
    OUTPUT
  end

  it "outputs a failure after a pass" do
    parse(stage: 'before_test',
          suite: 'flaky suite',
          test: 'a passing test')
    parse(stage: 'pass',
          suite: 'flaky suite',
          test: 'a passing test')
    parse(stage: 'before_test',
          suite: 'flaky suite',
          test: 'a failed test')
    parse(stage: 'failure',
          suite: 'flaky suite',
          test: 'a failed test')
    output.must_equal <<-OUTPUT
flaky suite

* a passing test#{reset}✔ a passing test
* a failed test#{reset}✘ a failed test
    OUTPUT
  end
end
