# coding: utf-8
require 'tempfile'
require 'ansi/code'
require_relative '../spec_helper'

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
    2.times do
      system('ruby spec/end-end/fixtures/examplespec.rb --seed=1234')
    end
    File.read(output.path).must_equal <<-OUTPUT
My Class

* is awesome#{reset}#{ANSI.green { "✔" }} is awesome
* can fail#{reset}#{ANSI.red { "✘" }} can fail

My Class

* is awesome#{reset}#{ANSI.green { "✔" }} is awesome
* can fail#{reset}#{ANSI.red { "✘" }} can fail
    OUTPUT
  end
end
