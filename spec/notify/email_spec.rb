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
    @email.stub(:body){"test body"}
    @email.to = "test_to"
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

  describe "when sending" do
    before do
      @smtp = mock(Net::SMTP)
      Net::SMTP.stub(:new){@smtp}
      @smtp.stub(:start).and_yield
      @smtp.stub(:send_message)
      @smtp.stub(:enable_starttls)
      @options = {}
    end

    describe "with an account" do
      it "should send with tls" do
        @smtp.should_receive(:enable_starttls)
        @email.send(@options)
      end

      it "should send" do
        @smtp.should_receive(:send_message).with("test body", "test_from", "test_to")
        @email.send(@options)
      end
    end

    describe "without an account" do
      before do
        @smtp.stub(:start).and_yield(@smtp)
        @email.account = nil
      end

      it "should not send with tls" do
        @smtp.should_not_receive(:enable_starttls)
        @email.send(@options)
      end

      it "should send" do
        @smtp.should_receive(:send_message).with("test body", "test_from", "test_to")
        @email.send(@options)
      end
    end

    describe "and loading options" do

      before do
        @email.to = "test_to"
        @email.send(@options)
      end

      it "should load a server if missing" do
        @options[:server].should eq("test_host")
      end

      it "should load a from address if missing" do
        @options[:from].should eq("test_from")
      end

      it "should load a subject if missing" do
        @options[:subject].should eq("New Build!")
      end

      it "should load a title if missing" do
        @options[:title].should eq("New Build!")
      end

      it "should load a body if missing" do
        @options[:body].should eq("test body")
      end

      it "should load a password if missing" do
        @options[:password].should eq("test_password")
      end

      it "should load an account if missing" do
        @options[:account].should eq("test_account")
      end

      it "should load a port if missing" do
        @options[:port].should eq(666)
      end

      it "should load a to address if missing" do
        @options[:to].should eq("test_to")
      end
    end
  end

end
