# coding: utf-8
require_relative '../../spec_helper'
require_relative '../../../lib/prawf/reporters'

describe "Prawf::MiniTestReporter" do
  it "writes test results to the given output object" do
    output, input = IO.pipe
    reporter = Prawf::MiniTestReporter.new(input)
    reporter.before_test('my suite', 'my test')
    input.close
    output.read.must_equal <<-OUTPUT
my suite

✓ my test
    OUTPUT
  end
end
