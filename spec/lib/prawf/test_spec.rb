require_relative '../../spec_helper'
require_relative '../../../lib/prawf/test'
require_relative '../../../lib/prawf/suite'

module Prawf
  describe Test do
    it "is equivalent to another test with same name and suite" do
      Test.new('foo', Suite.new('bar')).
        must_equal Test.new('foo', Suite.new('bar'))
    end
  end
end
