require 'spec_helper'
require 'yolo'

describe Yolo::Tasks::Ios::Release do
  before do
    @xcode = mock(Yolo::Tools::Ios::Xcode)
    @xcode.stub(:build_path)
    Yolo::Tools::Ios::Xcode.stub(:new){@xcode}

    @email = mock(Yolo::Notify::Ios::OTAEmail)
    @email.stub(:send)
    Yolo::Notify::Ios::OTAEmail.stub(:new){@email}

    @ota = mock(Yolo::Deployment::OTA)
    Yolo::Deployment::OTA.stub(:new){@ota}

    Yolo::Config::Settings.instance.stub(:bundle_directory){"test_directory"}

    Yolo::Formatters::ErrorFormatter.any_instance.stub(:puts)
    Yolo::Formatters::ProgressFormatter.any_instance.stub(:puts)

    @release = Yolo::Tasks::Ios::Release.new

    @test_path = "blah/name-test/Build/Products/Debug-iphoneos/name.app"
    @false_path = "blah/name-test/Build/Products/Release-iphoneos/name.app"
  end

  describe "when created" do
    it "should set iphoneos as the default sdk" do
      @release.sdk.should eq("iphoneos")
    end

    it "should set OTA as the default deployment" do
      @release.deployment.should eq(:OTA)
    end
  end

  describe "when getting the app path" do
    before do
      @release.stub(:name){"name"}
    end

    it "should find the directory" do
      Find.stub(:find).and_yield(@test_path)
      File.stub(:mtime){Time.now}
      @release.app_path.should eq(@test_path)
    end

    it "should find the latest directory" do
      Find.stub(:find).and_yield(@test_path).and_yield(@false_path)
      File.stub(:mtime).and_return(Time.now, Time.now - 1.day)
      @release.app_path.should eq(@test_path)
    end
  end

  describe "when getting the dsym path" do
    before do
      @release.stub(:app_path){"path/to/test.app"}
    end

    it "should get the path from the app path" do
      @release.dsym_path.should eq("path/to/test.app.dSYM")
    end
  end

  describe "when getting the bundle path" do
    before do
      @release.stub(:folder_name){"folder"}
      @release.stub(:version){"1.0"}
    end

    it "should generate the path" do
      @release.bundle_path.should eq("test_directory/folder/1.0")
    end
  end

  describe "when getting the folder name" do
    before do
      @release.stub(:name){"name"}
    end

    it "should append the configuration if present" do
      @release.configuration = "Debug"
      @release.folder_name.should eq("name-Debug")
    end

    it "should use the app name if no configuration is set" do
      @release.configuration = nil
      @release.folder_name.should eq("name")
    end
  end

  describe "when getting the info plist path" do
    before do
      @release.stub(:name){"name"}
      @path = "/path/to/name-Info.plist"
      Find.stub(:find).and_yield(@path)
    end

    it "should find the plist" do
      @release.info_plist_path.should eq(@path)
    end
  end

  describe "when getting the version" do
    before do
      @xcode.stub(:info_plist_path=)
    end

    it "should get the version string from xcode" do
      @xcode.stub(:version_number){"1.0"}
      @xcode.stub(:build_number){"1.0"}

      @release.version.should eq("1.0-1.0")
    end

    it "should use the current time if xcode cant find the version" do
      @xcode.stub(:version_number){nil}
      @xcode.stub(:build_number){nil}

      @time = mock(Time)
      Time.stub(:now){@time}
      @time.stub(:day){"Monday"}
      @time.stub(:month){"Jan"}
      @time.stub(:year){"2013"}
      @time.stub(:hour){"1"}
      @time.stub(:min){"1"}
      @time.stub(:sec){"1"}

      @release.version.should eq("Monday-Jan-2013-1-1-1")
    end
  end

  describe "when deploying" do
    before do
      @ota.stub(:deploy)
      @release.stub(:version){"1.0"}
      @release.stub(:name){"testname"}
    end

    it "should create a class from the deployment symbol" do
      @ota.should_receive(:deploy)
      @release.deploy("")
    end

    it "should not try and deploy a nil class" do
      Yolo::Deployment::OTA.stub(:new){nil}
      Yolo::Formatters::ErrorFormatter.any_instance.should_receive(:deployment_class_error)
      @release.deploy("")
    end

    it "shouldnt build mail options without a url" do
      @ota.stub(:deploy).and_yield(nil, nil)
      @email.should_not_receive(:send)
      @release.deploy("")
    end

    it "should build mail options once deployed" do
      @release.mail_to = "test@test.com"
      @ota.stub(:deploy).and_yield("url", "password")
      @email.should_receive(:send).with(
        {
          :to => "test@test.com",
          :ota_url => "url",
          :subject=>"New testname build: 1.0",
          :title=>"testname",
          :ota_password=>"password"
        })
      @release.deploy("")
    end
  end
end
