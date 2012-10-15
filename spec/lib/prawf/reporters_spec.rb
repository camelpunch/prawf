# coding: utf-8
require_relative '../../spec_helper'
require_relative '../../../lib/prawf/reporters'
require 'json'

describe Prawf::MiniTestReporter do
  attr_reader :pipe_output, :pipe_input
  let(:unused_test_runner) { nil }
  let(:unused_suites) { nil }
  let(:unused_type) { nil }
  let(:reporter) { Prawf::MiniTestReporter.new(pipe_input) }
  let(:output) { pipe_input.close; pipe_output.read }

  before do
    @pipe_output, @pipe_input = IO.pipe
  end

  it "writes before-suite data" do
    reporter.before_suite('my suite')

    expected_json = JSON.generate(
      stage: 'before_suite',
      suite: 'my suite'
    )

    output.must_equal "#{expected_json}\n"
  end

  it "writes before-test data" do
    reporter.before_test('my suite', 'test_0002_my test')

    expected_json = JSON.generate(
      stage: 'before_test',
      suite: 'my suite',
      test: 'my test'
    )

    output.must_equal "#{expected_json}\n"
  end

  it "writes passed test data" do
    reporter.pass('my suite', 'test_0001_my test', unused_test_runner)

    expected_json = JSON.generate(
      stage: 'pass',
      suite: 'my suite',
      test: 'my test'
    )

    output.must_equal "#{expected_json}\n"
  end

  it "writes failed test data" do
    reporter.failure('my suite', 'test_0001_my test', unused_test_runner)

    expected_json = JSON.generate(
      stage: 'failure',
      suite: 'my suite',
      test: 'my test'
    )

    output.must_equal "#{expected_json}\n"
  end

  it "writes before-suites data" do
    reporter.before_suites(unused_suites, unused_type)

    expected_json = JSON.generate(
      stage: 'before_suites'
    )

    output.must_equal "#{expected_json}\n"
  end

  it "writes after-suites data" do
    reporter.after_suites(unused_suites, unused_type)

    expected_json = JSON.generate(
      stage: 'after_suites'
    )

    output.must_equal "#{expected_json}\n"
  end
end
