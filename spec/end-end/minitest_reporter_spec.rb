# coding: utf-8
require_relative '../spec_helper'
require 'ansi/code'

describe "Prawf's minitest reporter" do
  def run_command(command)
    @pipes ||= []
    IO.popen(command, 'r').tap do |pipe|
      @pipes << pipe
    end
  end

  before do
    @prawf_output = run_command('bin/prawf /tmp/prawfpipe')
  end

  after do
    Process.kill 'KILL', *@pipes.map(&:pid)
  end

  it "displays output nicely" do
    num_lines = 3
    run_command 'ruby spec/end-end/fixtures/example_spec.rb'

    lines = (1..num_lines).inject('') {|output, n|
      output << @prawf_output.gets
      output
    }

    lines.must_equal <<-OUTPUT
My Class

✓ is awesome
    OUTPUT
  end
end
