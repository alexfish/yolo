require 'spec_helper'

describe Yolo::Notify::Ios::OTAEmail do

  before do
    Yolo::Formatters::ErrorFormatter.any_instance.stub(:puts)
    Yolo::Formatters::ProgressFormatter.any_instance.stub(:puts)

    @settings = Yolo::Config::Settings
    @settings.any_instance.stub(:mail_host){"test_host"}
    @settings.any_instance.stub(:mail_from){"test_from"}
    @settings.any_instance.stub(:mail_port){666}
    @settings.any_instance.stub(:mail_account){"test_account"}
    @settings.any_instance.stub(:mail_password){"test_password"}

    @options = {:ota_password => "test_password", :ota_url => "test_url", :title => "test_title", :subject => "test subject"}

    Yolo::Tools::Ios::ReleaseNotes.stub(:html){"test markdown"}
  end

  describe "when generating the body" do
    before do
      @email = Yolo::Notify::Ios::OTAEmail.new
      file = mock(File)
      file.stub(:read){"YOLO.TITLE YOLO.CONTENT YOLO.PASSWORD YOLO.LINK"}
      File.stub(:open){file}
    end

    it "should contain the subject" do
      @email.body(@options).should match(/test subject/)
    end

    it "should contain the password" do
      @email.body(@options).should match(/test_password/)
    end

    it "should contain the link" do
      @email.body(@options).should match(/test_url/)
    end

    it "should contain the markdown" do
      @email.body(@options).should match(/test markdown/)
    end

    it "should contain the title" do
      @email.body(@options).should match(/test_title/)
    end

    it "should remove the template password if password is missing" do
      @options[:ota_password] = nil
      @email.body(@options).should_not match(/YOLO.PASSWORD/)
    end
  end
end
