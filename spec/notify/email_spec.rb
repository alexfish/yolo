require 'spec_helper'
require 'yolo'

describe Yolo::Notify::Email do

  before do
    Yolo::Formatters::ErrorFormatter.any_instance.stub(:puts)
    Yolo::Formatters::ProgressFormatter.any_instance.stub(:puts)

    @error_formatter = mock(Yolo::Formatters::ErrorFormatter)
    Yolo::Formatters::ErrorFormatter.stub(:new){@error_formatter}

    @settings = Yolo::Config::Settings
    @settings.any_instance.stub(:mail_host){"test_host"}
    @settings.any_instance.stub(:mail_from){"test_from"}
    @settings.any_instance.stub(:mail_port){666}
    @settings.any_instance.stub(:mail_account){"test_account"}
    @settings.any_instance.stub(:mail_password){"test_password"}
    @email = Yolo::Notify::Email.new
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

    it "should return an empty body" do
      @email.body({}).should eq("")
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
      @email.stub(:body){"test body"}
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
        @email.stub(:body){"test body"}
      end

      it "should not send with tls" do
        @smtp.should_not_receive(:enable_starttls)
        @email.send(@options)
      end

      it "should send" do
        @smtp.should_receive(:send_message).with("test body", "test_from", "test_to")
        @email.send(@options)
      end

      it "should output an error if missing details" do
        @email.server = nil
        @error_formatter.should_receive(:missing_email_details)
        @email.send(@options)
      end
    end

    describe "and loading options" do

      before do
        @email.to = "test_to"
        @email.send(@options)
        @email.stub(:body){"test body"}
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
