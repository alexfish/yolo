require 'spec_helper'
require 'yolo/tools/ios/calabash'

describe Yolo::Tools::Ios::Calabash do

  before do
    IO.stub(:popen)
  end

  describe "when running " do

    before do
      @io = mock(IO)
      IO.stub(:popen).and_yield(@io)
      @io.stub(:readline)
    end

    it "should execute the cucumber command" do
      IO.should_receive(:popen).with(/cucumber/)
      Yolo::Tools::Ios::Calabash.run()
    end

    it "should pass junit as the default format" do
      IO.should_receive(:popen).with(/--format junit/)
      Yolo::Tools::Ios::Calabash.run()
    end

    it "pass test-reports/cucumber as the default output directory" do
      IO.should_receive(:popen).with(/--out test-reports\/cucumber/)
      Yolo::Tools::Ios::Calabash.run()
    end

    it "should output to STDOUT" do
      @io.stub(:readline).and_return("testline", nil)
      Yolo::Tools::Ios::Calabash.should_receive(:puts).with("testline")
      Yolo::Tools::Ios::Calabash.run
    end

    it "should catch EOFError exceptions" do
      @io.stub(:readline).and_raise(EOFError)
      Yolo::Tools::Ios::Calabash.should_receive(:puts)
      Yolo::Tools::Ios::Calabash.run
    end

  end

end
