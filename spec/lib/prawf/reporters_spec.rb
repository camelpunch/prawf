# coding: utf-8
require 'tempfile'
require 'json'
require_relative '../../spec_helper'
require_relative '../../../lib/prawf/reporters'

describe Prawf::MiniTestReporter do
  let(:unused_test_runner) { nil }
  let(:unused_suites) { nil }
  let(:unused_type) { nil }
  let(:reporter) { Prawf::MiniTestReporter.new(@file) }
  let(:output) { File.read(@file.path) }

  before do
    @file = Tempfile.new('reporter test')
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
    test_runner = MiniTest::TestRunner.new(
      suite = nil, test = nil, assertions = nil, time = nil, result = nil,
      exception = StandardError.new('bad things!')
    )
    reporter.failure('my suite', 'test_0001_my test', test_runner)

    expected_json = JSON.generate(
      stage: 'failure',
      suite: 'my suite',
      test: 'my test',
      message: 'bad things!'
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
