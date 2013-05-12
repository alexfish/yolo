require 'spec_helper'

describe Yolo::Tools::Ios::IPA do

  before do
    @ipa = Yolo::Tools::Ios::IPA
    Yolo::Formatters::ProgressFormatter.any_instance.stub(:puts)
  end

  describe "when generating an ipa" do
    before do
      @ipa.stub(:`)
      @ipa.stub(:move_file)
      @ipa.stub(:move_release_notes)
      FileUtils.stub(:mkdir_p)
    end

    it "should return the ipa path" do
      @ipa.stub(:app_name){"name"}
      @ipa.generate("","","output") do |ipa|
        ipa.should eq("output/name.ipa")
      end
    end

    it "should calculate the name from the app path" do
      @ipa.app_name("/path/to/app/test.app").should eq("test")
    end

    describe "and executing" do
      it "should execute xcrun" do
        @ipa.stub(:app_name)
        @ipa.should_receive(:`).with(/\/usr\/bin\/xcrun/)
        @ipa.generate("","","")
      end

      it "should pacakge the app" do
        @ipa.stub(:app_name)
        @ipa.should_receive(:`).with(/PackageApplication -v app\/path/)
        @ipa.generate("app/path","","")
      end

      it "should set the sdk to iphoneos" do
        @ipa.stub(:app_name)
        @ipa.should_receive(:`).with(/-sdk iphoneos/)
        @ipa.generate("","","")
      end
    end

    describe "and outputting the ipa" do
      before do
        @ipa.stub(:app_name)
      end

      it "should create an output directory if missing" do
        File.stub(:directory?){false}
        FileUtils.should_receive(:mkdir_p).with("output/path")
        @ipa.create_directory("output/path")
      end

      it "should output to the output directory" do
        @ipa.stub(:create_directory)
        @ipa.stub(:app_name){"test"}
        @ipa.should_receive(:`).with(/-o output\/path\/test.ipa/)
        @ipa.generate("","","output/path")
      end

      it "should move files into place" do
        @ipa.should_receive(:move_file)
        @ipa.generate("","","")
      end

      it "should move release notes into place" do
        @ipa.should_receive(:move_release_notes)
        @ipa.generate("","","")
      end
    end
  end

  describe "when moving files" do
    it "should move them" do
      FileUtils.stub(:cp_r)
      FileUtils.should_receive(:cp_r).with("file","dir")
      @ipa.move_file("file","dir")
    end

    it "should not attempt to move nil files" do
      FileUtils.should_not_receive(:cp_r)
      @ipa.move_file(nil,"dir")
    end

    it "should move release notes" do
      Dir.stub(:pwd){"path"}
      File.stub("exist?"){true}
      FileUtils.should_receive(:cp_r).with("path/release_notes.md", "dir")
      @ipa.move_release_notes("dir")
    end

    it "should not attempt to move nil" do
      File.stub("exist?"){false}
      Dir.stub(:pwd){"path"}
      FileUtils.should_not_receive(:cp_r)
      @ipa.move_release_notes("dir")
    end
  end
end
