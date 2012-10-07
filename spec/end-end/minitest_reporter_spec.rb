# coding: utf-8
require_relative '../spec_helper'
require 'tempfile'

describe "Prawf's minitest reporter" do
  let(:output) { Tempfile.new('prawf output') }

  before do
    File.unlink '/tmp/prawfpipe' rescue nil
    @pid = Process.spawn('bin/prawf /tmp/prawfpipe',
                         :out => output.path,
                         :err => output.path)
  end

  after do
    Process.kill 'KILL', @pid
  end

  it "displays output nicely" do
    system('ruby spec/end-end/fixtures/examplespec.rb')

    File.read(output.path).must_equal <<-OUTPUT
My Class

✓ is awesome
    OUTPUT
  end
end
