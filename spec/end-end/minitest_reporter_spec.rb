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

  let(:reset) {
    cr = "\r"
    clear = "\e[0K"
    cr + clear
  }

  it "displays output nicely" do
    system('ruby spec/end-end/fixtures/examplespec.rb --seed=1234')
    File.read(output.path).must_equal <<-OUTPUT
My Class

* is awesome#{reset}✔ is awesome
* can fail#{reset}✘ can fail
    OUTPUT
  end
end
