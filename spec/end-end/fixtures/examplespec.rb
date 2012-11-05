gem 'minitest'
require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/reporters'
require_relative '../../../lib/prawf/reporters'

MiniTest::Reporters.use!(
  Prawf::MiniTestReporter.new(
    File.open('/tmp/prawfpipe', 'w+')
  )
)

describe "My Class" do
  it "is awesome" do
    true.must_equal true
  end

  it "can fail" do
    true.must_equal false
  end
end
