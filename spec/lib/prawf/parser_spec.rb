# coding: utf-8
require_relative '../../spec_helper'
require_relative '../../../lib/prawf/parser'

describe Prawf::Parser do
  it "outputs the first before-test as a suite heading" do
    output, input = IO.pipe
    parser = Prawf::Parser.new(input)
    2.times do
      parser.parse JSON.generate(
        stage: 'before_test',
        suite: 'some suite',
        test: 'a test'
      )
    end
    input.close

    output.read.must_equal <<-OUTPUT
some suite

    OUTPUT
  end

  it "outputs a pass" do
    output, input = IO.pipe
    parser = Prawf::Parser.new(input)
    parser.parse JSON.generate(
      stage: 'pass',
      suite: 'some suite',
      test: 'a test'
    )
    input.close

    output.read.must_equal <<-OUTPUT
✔ a test
    OUTPUT
  end

  it "outputs a failure" do
    output, input = IO.pipe
    parser = Prawf::Parser.new(input)
    parser.parse JSON.generate(
      stage: 'failure',
      suite: 'flaky suite',
      test: 'a failed test'
    )
    input.close

    output.read.must_equal <<-OUTPUT
✘ a failed test
    OUTPUT
  end
end
