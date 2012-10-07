# coding: utf-8
require_relative '../../spec_helper'
require_relative '../../../lib/prawf/parser'

describe Prawf::Parser do
  it "outputs before-tests as passes (for now)" do
    output, input = IO.pipe
    parser = Prawf::Parser.new(input)
    parser.parse JSON.generate(
      stage: 'before_test',
      suite: 'some suite',
      test: 'a test'
    )
    input.close

    output.read.must_equal <<-OUTPUT
some suite

✔ a test
    OUTPUT
  end
end
