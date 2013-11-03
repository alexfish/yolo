require 'spec_helper'
require 'yolo'

describe Yolo::Deployment::OTA do

  before do
    @error_formatter = Yolo::Formatters::ErrorFormatter.new
    Yolo::Formatters::ErrorFormatter.stub(:new){@error_formatter}

    Yolo::Formatters::ErrorFormatter.any_instance.stub(:puts)
    Yolo::Formatters::ProgressFormatter.any_instance.stub(:puts)
    Yolo::Formatters::ProgressFormatter.any_instance.stub(:deploying_ipa)

    @ota = Yolo::Deployment::OTA.new
  end

  describe "when deploying" do
    before do
      @ota.stub(:upload)
    end

    after do
      @ota = Yolo::Deployment::OTA.new
    end

    it "should deploy a package" do
      @ota.should_receive(:upload)
      @ota.url = "test"
      @ota.deploy("test_path")
      @ota.package_path.should eq("test_path")
    end

    it "should not deploy without a deploy url" do
      @ota.should_not_receive(:upload)
      @ota.url = nil
      @ota.deploy("test_path")
    end
  end

  describe "when packaging" do
    it "should get the file name from the path" do
      @ota.package_path = "path/to/filename.app"
      @ota.package.should match(/\"fileName\": \"filename.app\"/)
    end

    it "should set an expiry date" do
      @ota.package_path = "path/to/filename.app"
      @ota.package.should match(/\"validUntil\"/)
    end
  end

  describe "when uploading" do
    before do
      @io = mock(IO)
      @io.stub(:readline)
      @ota.stub(:package)
      IO.stub(:popen).and_yield(@io)
    end

    it "should curl to the correct url" do
      @ota.url = "test.com"
      IO.should_receive(:popen).with(/curl test.com/)
      @ota.upload
    end

    it "should catch empty responses" do
      @io.stub(:readline){nil}
      @error_formatter.should_receive(:deploy_failed).at_least(1).times
      @ota.upload
    end

    it "should parse the response" do
      @io.stub(:readline).and_return("response string", nil)
      @ota.should_receive(:upload_complete).with("response string")
      @ota.upload
    end

    it "should not complete with a nil response" do
      @io.should_not_receive(:upload_complete)
      @ota.upload
    end
  end

  describe "when upload completes" do
    before do
      @ota.stub(:upload)
    end

    it "should catch json parse errors" do
      @error_formatter.should_receive(:deploy_failed)
      @ota.upload_complete("json")
    end

    it "should not continue if json parsing fails" do
      JSON.stub(:parse){nil}
      @error_formatter.should_receive(:deploy_failed)
      @ota.upload_complete("json")
    end

    it "should parse the response" do
      @ota.deploy("test", nil) do |url, password|
        password.should eq("test_password")
        url.should eq("test_link")
      end
      @ota.upload_complete('{"link":"test_link","password":"test_password"}')
    end
  end
end
