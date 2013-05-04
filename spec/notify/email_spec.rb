require 'spec_helper'
require 'yolo/notify/email'
require 'yolo/formatters'
require 'yolo/config'

describe Yolo::Notify::Email do

  before do
    Yolo::Formatters::ErrorFormatter.any_instance.stub(:puts)
    Yolo::Formatters::ProgressFormatter.any_instance.stub(:puts)

    @settings = Yolo::Config::Settings
    @settings.any_instance.stub(:mail_host){"test_host"}
    @settings.any_instance.stub(:mail_from){"test_from"}
    @settings.any_instance.stub(:mail_port){666}
    @settings.any_instance.stub(:mail_account){"test_account"}
    @settings.any_instance.stub(:mail_password){"test_password"}
    @email = Yolo::Notify::Email.new
  end

  describe "when initilized" do
    it "should load a server" do
      @email.server.should eq("test_host")
    end

    it "should load a from address" do
      @email.from.should eq("test_from")
    end

    it "should load a port" do
      @email.port.should eq(666)
    end

    it "should load an account" do
      @email.account.should eq("test_account")
    end

    it "should load a password" do
      @email.password.should eq("test_password")
    end
  end

  pending "send tests" do
    it "needs to be written" do
    end
  end

end
