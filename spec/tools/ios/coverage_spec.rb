require 'spec_helper'
require 'yolo'

describe Yolo::Tools::Ios::Coverage do

  before do
    Yolo::Formatters::ErrorFormatter.any_instance.stub(:puts)
    IO.stub(:popen)
  end

  describe "when calculating coverage" do
    it "should require a build path" do
      IO.should_not_receive(:popen)
      Yolo::Tools::Ios::Coverage.calculate("","test")
    end

    it "should require a output path" do
      IO.should_not_receive(:popen)
      Yolo::Tools::Ios::Coverage.calculate("test","")
    end

    it "should execute gcovr" do
      IO.should_receive(:popen).with(/gcovr/)
      Yolo::Tools::Ios::Coverage.calculate("test","test")
    end

    it "should execute at the build path" do
      IO.should_receive(:popen).with(/cd test/)
      Yolo::Tools::Ios::Coverage.calculate("test","test")
    end

    it "should output xml to the output path" do
      IO.should_receive(:popen).with(/--xml > test\/coverage.xml/)
      Yolo::Tools::Ios::Coverage.calculate("test","test")
    end
  end

  describe "when calculating coverage fails" do

    before do
      @io = mock(IO)
      IO.stub(:popen).and_yield(@io)
    end

    it "should catch EOFError exceptions" do
      @io.stub(:readline).and_raise(EOFError)
      Yolo::Tools::Ios::Coverage.should_receive(:puts)
      Yolo::Tools::Ios::Coverage.calculate("test","test")
    end
  end
end
