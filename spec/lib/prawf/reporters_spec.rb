# coding: utf-8
require_relative '../../spec_helper'
require_relative '../../../lib/prawf/reporters'
require 'json'

describe Prawf::MiniTestReporter do
  it "writes before-test data" do
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

  # it "writes passed test data" do
    # unused_test_runner = nil

    # output, input = IO.pipe
    # reporter = Prawf::MiniTestReporter.new(input)
    # reporter.pass('my suite', 'my test', unused_test_runner)
    # input.close

    # expected_json = JSON.generate(
      # stage: 'pass',
      # suite: 'my suite',
      # test: 'my test'
    # )

    # output.gets.must_equal "#{expected_json}\n"
  # end

  # it "writes failed test data" do
    # unused_test_runner = nil

    # output, input = IO.pipe
    # reporter = Prawf::MiniTestReporter.new(input)
    # reporter.failure('my suite', 'my test', unused_test_runner)
    # input.close

    # expected_json = JSON.generate(
      # stage: 'failure',
      # suite: 'my suite',
      # test: 'my test'
    # )

    # output.gets.must_equal "#{expected_json}\n"
  # end
end
