require 'spec_helper'
require 'yolo/tools/ios/calabash'

describe Yolo::Tools::Ios::Calabash do

  before do
    IO.stub(:popen)
  end

  describe "when running " do

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

  end

end
