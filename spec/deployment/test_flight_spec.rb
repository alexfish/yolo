require 'spec_helper'

describe Yolo::Deployment::TestFlight do

   before do
    @error_formatter = Yolo::Formatters::ErrorFormatter.new
    Yolo::Formatters::ErrorFormatter.stub(:new){@error_formatter}
    @error_formatter.stub(:deploy_failed)
    Yolo::Formatters::ErrorFormatter.any_instance.stub(:puts)
    Yolo::Formatters::ProgressFormatter.any_instance.stub(:puts)
    Yolo::Formatters::ProgressFormatter.any_instance.stub(:deploying_ipa)
    Yolo::Tools::Ios::ReleaseNotes.stub(:plaintext)
    @tf = Yolo::Deployment::TestFlight.new
    @tf.instance_variable_set(:@error_formatter, @error_formatter)
  end

  describe "when deploying" do
    before do
      @tf.stub(:curl_string){"curlstring"}
      @tf.stub(:upload_complete)
      @io = mock(IO)
      @io.stub(:readline)
      IO.stub(:popen).and_yield(@io)
    end

    it "should execute a curl string" do
      IO.should_receive(:popen).with("curlstring")
      @tf.deploy("test")
    end

    it "should catch StandardError exceptions" do
      @io.stub(:readline).and_raise(StandardError)
      @error_formatter.should_receive(:deploy_failed).at_least(1).times
      @tf.deploy("test")
    end

    it "should parse the response" do
      @io.stub(:readline).and_return("response string", nil)
      @tf.should_receive(:upload_complete).with("response string")
      @tf.deploy("test")
    end

    it "should not complete with a nil response" do
      @io.should_not_receive(:upload_complete)
      @tf.deploy("test")
    end
  end

  describe "when parsing options" do
    it "should parse the distribution lists" do
      @tf.instance_eval{distribution_lists({:distribution_lists => ["test", "test"]})}.should eq("test,test")
    end

    it "should parse the notify option" do
      @tf.instance_eval{notify({:notify => true})}.should eq("True")
    end
  end

  describe "when loading settings" do
    it "should load the api token" do
      Yolo::Config::Settings.instance.stub(:api_token){"apitoken"}
      @tf.instance_eval{api_token}.should eq("apitoken")
    end

    it "should load the team token" do
      Yolo::Config::Settings.instance.stub(:team_token){"teamtoken"}
      @tf.instance_eval{team_token}.should eq("teamtoken")
    end
  end

  describe "when loading notes" do
    it "should set default notes" do
      @tf.instance_eval{notes}.should eq("No notes provided")
    end

    it "should load notes from release notes" do
      Yolo::Tools::Ios::ReleaseNotes.stub(:plaintext){"test notes"}
      @tf.instance_eval{notes}.should eq("test notes")
    end
  end

  describe "when the upload completes" do
    before do
      @io = mock(IO)
      IO.stub(:popen).and_yield(@io)
    end

    it "should catch json parse errors" do
      @error_formatter.should_receive(:deploy_failed)
      @tf.instance_eval{upload_complete("json")}
    end

    it "should parse the response" do
      @io.stub(:readline).and_return('{"install_url":"test_link"}', nil)
      @tf.deploy("test", nil) do |url, password|
        url.should eq("test_link")
      end
    end
  end

  describe "when building a curl string" do
    before do
      @tf.stub(:api_token){"apitoken"}
      @tf.stub(:team_token){"teamtoken"}
      @tf.stub(:notes){"notes"}
      @tf.stub(:notify){"notify"}
      @tf.stub(:distribution_lists){"list"}
    end

    it "should use curl" do
      @tf.instance_eval{curl_string("test", nil)}.should match(/curl/)
    end

    it "should set the correct URL" do
      @tf.instance_eval{curl_string("test", nil)}.should match(/http:\/\/testflightapp.com\/api\/builds.json/)
    end

    it "should be a post request" do
      @tf.instance_eval{curl_string("test", nil)}.should match(/-X POST -#/)
    end

    it "should set the file path" do
      @tf.instance_eval{curl_string("test", nil)}.should match(/-F file=@test/)
    end

    it "should set the api token" do
      @tf.instance_eval{curl_string("test", nil)}.should match(/-F api_token='apitoken'/)
    end

    it "should set the team token" do
      @tf.instance_eval{curl_string("test", nil)}.should match(/-F team_token='teamtoken'/)
    end

    it "should set the notes" do
      @tf.instance_eval{curl_string("test", nil)}.should match(/-F notes='notes'/)
    end

    it "should set the notify string" do
      @tf.instance_eval{curl_string("test", {})}.should match(/-F notify=notify/)
    end

    it "should set the distribution lists" do
      @tf.instance_eval{curl_string("test", {})}.should match(/-F distribution_lists=list/)
    end

    it "should not set notify with no options" do
      @tf.instance_eval{curl_string("test", nil)}.should_not match(/-F notify=notify/)
    end

    it "should not set distribution lists with no options" do
      @tf.instance_eval{curl_string("test", nil)}.should_not match(/-F distribution_lists=list/)
    end
  end
end
