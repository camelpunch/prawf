# coding: utf-8
require_relative '../../spec_helper'
require_relative '../../../lib/prawf/reporters'
require 'json'

describe "Prawf::MiniTestReporter" do
  it "writes test results to the given output object" do
    output, input = IO.pipe
    reporter = Prawf::MiniTestReporter.new(input)
    reporter.before_test('my suite', 'my test')
    input.close

    expected_json = JSON.generate(
      stage: 'before_test',
      suite: 'my suite',
      test: 'my test'
    )

    output.gets.must_equal "#{expected_json}\n"
  end
end
