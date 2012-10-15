# coding: utf-8
require_relative '../../spec_helper'
require_relative '../../../lib/prawf/parser'
require 'rr'

module Prawf
  describe Parser do
    include RR::Adapters::RRMethods

    attr_reader :message_output, :message_input,
      :error_output, :error_input

    before do
      @message_output, @message_input = IO.pipe
      @error_output, @error_input = IO.pipe
    end

    after do
      RR.verify
    end

    let(:outputter) { Object.new }
    let(:parser) { Parser.new(outputter) }
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
      mock(outputter).error('Invalid JSON received: {')
      parser.parse '{'
    end

    it "outputs an error when given incomprehensible JSON" do
      mock(outputter).error('Invalid instruction received: { "foo": "bar" }')
      parser.parse '{ "foo": "bar" }'
    end

    it "sends before-suite data to the outputter" do
      parse(stage: 'before_suites')

      expected_suite = Suite.new('a great suite')
      mock(outputter).before_suite(expected_suite)
      parse(stage: 'before_suite', suite: 'a great suite')

      parse(stage: 'after_suites')
    end

    it "sends before-test data to the outputter" do
      parse(stage: 'before_suites')

      stub(outputter).before_suite
      parse(stage: 'before_suite', suite: 'any old suite')

      expected_test = Test.new('before-test test', Suite.new('any old suite'))
      mock(outputter).before_test(expected_test)
      parse(stage: 'before_test',
            suite: 'any old suite',
            test: 'before-test test')

      parse(stage: 'after_suites')
    end

    it "sends passes to the outputter" do
      parse(stage: 'before_suites')

      stub(outputter).before_suite
      parse(stage: 'before_suite', suite: 'a suite')

      stub(outputter).before_test
      parse(stage: 'before_test', suite: 'a suite', test: 'a test')

      expected_test = Test.new('a test', Suite.new('a suite'))
      mock(outputter).pass(expected_test)
      parse(stage: 'pass', suite: 'a suite', test: 'a test')

      parse(stage: 'after_suites')
    end

    it "sends failures to the outputter" do
      parse(stage: 'before_suites')

      stub(outputter).before_suite
      parse(stage: 'before_suite', suite: 'a suite')

      stub(outputter).before_test
      parse(stage: 'before_test', suite: 'a suite', test: 'a test')

      expected_test = Test.new('a test', Suite.new('a suite'))
      mock(outputter).fail(expected_test)
      parse(stage: 'failure', suite: 'a suite', test: 'a test')

      parse(stage: 'after_suites')
    end
  end
end
