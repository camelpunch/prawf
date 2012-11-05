# coding: utf-8
require 'tempfile'
require 'ansi/code'
require_relative '../spec_helper'

describe "Prawf's minitest reporter" do
  let(:output) { Tempfile.new('prawf message output') }
  let(:reset) {
    cr = "\r"
    clear = "\e[0K"
    cr + clear
  }

  before do
    File.unlink '/tmp/prawfpipe' rescue nil
    @pid = Process.spawn('bin/prawf /tmp/prawfpipe',
                         :out => output.path,
                         :err => $stderr)
  end

  after do
    Process.kill 'KILL', @pid if @pid
  end

  it "displays output nicely" do
    2.times do
      system('ruby spec/end-end/fixtures/examplespec.rb --seed=1234')
    end

    File.read(output.path).must_equal <<-OUTPUT
MiniTest::Spec

My Class

* is awesome#{reset}#{ANSI.green { "✔" }} is awesome
* can fail#{reset}#{ANSI.red { "✘" }} can fail
  Expected: false
    Actual: true
  (eval):8:in `must_equal'
  spec/end-end/fixtures/examplespec.rb:19:in `block (2 levels) in <main>'

MiniTest::Spec

My Class

* is awesome#{reset}#{ANSI.green { "✔" }} is awesome
* can fail#{reset}#{ANSI.red { "✘" }} can fail
  Expected: false
    Actual: true
  (eval):8:in `must_equal'
  spec/end-end/fixtures/examplespec.rb:19:in `block (2 levels) in <main>'

    OUTPUT
  end
end
