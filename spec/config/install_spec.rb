require 'spec_helper'

describe Yolo::Config::Install do
  describe "when installing" do
    before do
      Yolo::Formatters::ProgressFormatter.any_instance.stub(:puts)
      FileUtils.stub(:cp_r)
      FileUtils.stub(:mv)
      File.stub(:dirname){"current"}
      Dir.stub(:pwd){"current"}
      @default_rakefile = "current/yolo-Rakefile"
    end

    it "should copy the default rakefile into place" do
      Yolo::Config::Install.stub(:`)
      FileUtils.should_receive(:cp_r).with(@default_rakefile, "current")
      Yolo::Config::Install.run
    end

    it "should remove the yolo prefix from the default rake file" do
      FileUtils.should_receive(:mv).with("current/yolo-Rakefile","current/Rakefile")
      Yolo::Config::Install.rename_rakefile
    end
  end
end
