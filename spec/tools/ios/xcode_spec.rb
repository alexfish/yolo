require 'spec_helper'

describe Yolo::Tools::Ios::Xcode do
  before do
    @xcode = Yolo::Tools::Ios::Xcode.new
    Yolo::Formatters::ErrorFormatter.any_instance.stub(:puts)
  end

  describe "on init" do
    it "should load a preferences file path" do
      @xcode.prefs_plist_path.should_not eq(nil)
    end

    it "should load an info plist path" do
      xcode = Yolo::Tools::Ios::Xcode.new("path")
      xcode.info_plist_path.should eq("path")
    end
  end

  describe "when loading plists" do
    it "shoud load xcode's preferences" do
      @plist = ""
      @plist.stub(:value)
      @xcode.stub(:prefs_plist_path){"path"}
      CFPropertyList::List.stub(:new){@plist}
      CFPropertyList::List.should_receive(:new).with({:file => "path"})
      @xcode.prefs
    end
  end

  describe "when loading xcode preferences" do
    it "should recognise a custom build folder location" do
      @xcode.stub(:prefs){{"IDECustomDerivedDataLocation" => "path"}}
      @xcode.build_path.should eq("path")
    end

    it "should recognise a default build folder location" do
      @xcode.stub(:prefs){{}}
      File.stub(:expand_path){"path"}
      @xcode.build_path.should eq("path/Library/Developer/Xcode/DerivedData")
    end
  end

  describe "when loading the info.plist" do
    it "should recognise if the plist path is not set" do
      @xcode.info_plist_path = nil
      Yolo::Formatters::ErrorFormatter.any_instance.should_receive(:info_plist_not_found)
      @xcode.info_plist
    end

    it "should load the info plist" do
      @plist = ""
      @plist.stub(:value)
      CFPropertyList::List.stub(:new){@plist}
      @xcode.info_plist_path = "path"
      CFPropertyList::List.should_receive(:new).with({:file => "path"})
      @xcode.info_plist
    end

    it "should load the build number from the info plist" do
      @xcode.stub(:info_plist){{"CFBundleVersion" => 10}}
      @xcode.build_number.should eq(10)
    end

    it "should load the version number from the info plist" do
      @xcode.stub(:info_plist){{"CFBundleShortVersionString" => 10}}
      @xcode.version_number.should eq(10)
    end
  end
end
