require_relative '../../spec_helper'
require_relative '../../../lib/prawf/suite'

describe Prawf::Suite do
  it "is equivalent to another suite with same name" do
    Prawf::Suite.new('foo').must_equal Prawf::Suite.new('foo')
  end
end
