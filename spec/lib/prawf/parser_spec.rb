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

  def parse(attributes)
    parser.parse JSON.generate(attributes)
  end

  it "outputs the first before-test as a suite heading" do
    2.times do
      parse(
        stage: 'before_test',
        suite: 'some suite',
        test: 'a test'
      )
    end
    output.must_equal <<-OUTPUT
some suite

    OUTPUT
  end

  it "outputs a pass" do
    parse(
      stage: 'pass',
      suite: 'some suite',
      test: 'a test'
    )
    output.must_equal <<-OUTPUT
✔ a test
    OUTPUT
  end

  it "outputs a failure" do
    parse(
      stage: 'failure',
      suite: 'flaky suite',
      test: 'a failed test'
    )
    output.must_equal <<-OUTPUT
✘ a failed test
    OUTPUT
  end
end
