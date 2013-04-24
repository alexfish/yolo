require 'spec_helper'
require 'yolo/tools/ios/xcode'
require 'yolo/tools/ios/release_notes'
require 'yolo/formatters'

describe Yolo::Tools::Ios::ReleaseNotes do

  before do
    @xcode = Yolo::Tools::Ios::Xcode.new
    Yolo::Tools::Ios::Xcode.stub(:new){@xcode}
    @xcode.stub(:info_plist_path)
    @xcode.stub(:version_number)
    @xcode.stub(:build_number)
    @release_notes = Yolo::Tools::Ios::ReleaseNotes
    Yolo::Formatters::ProgressFormatter.any_instance.stub(:puts)
  end

  describe "When generating release notes" do

    before do
      Dir.stub(:pwd){"current_path"}
      @file = mock(File)
      @file.stub(:write)
      File.stub(:open).and_yield(@file)
      @release_notes.stub(:`)
    end

    it "should pass a plist path to xcode" do
      @xcode.should_receive(:info_plist_path=).with("path")
      @release_notes.generate("path")
    end

    it "should use the current directory" do
      Dir.should_receive(:pwd)
      @release_notes.generate("path")
    end

    it "should use the builds version number" do
      @xcode.should_receive(:version_number)
      @release_notes.generate("path")
    end

    it "should use the builds build number" do
      @xcode.should_receive(:build_number)
      @release_notes.generate("path")
    end

    it "should use the current time" do
      @time = Time.new
      Time.stub(:new){@time}
      @time.should_receive(:day)
      @time.should_receive(:month)
      @time.should_receive(:year)
      @time.should_receive(:hour)
      @time.should_receive(:min)
      @release_notes.generate("path")
    end

    it "should open the release notes after writting" do
      @release_notes.should_receive(:`).with(/open current_path\/release_notes.md/)
      @release_notes.generate("path")
    end
  end
end
