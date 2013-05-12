require 'spec_helper'

describe Yolo::Config::Settings do

  before do
    Yolo::Config::Settings.instance.stub(:yolo_dir){"test_dir"}
    FileUtils.stub(:cp_r)
    FileUtils.stub(:mkdir_p)
    Yolo::Formatters::ProgressFormatter.any_instance.stub(:puts)
    Yolo::Formatters::ErrorFormatter.any_instance.stub(:puts)
  end

  it "should be a singleton" do
    Yolo::Config::Settings.instance.should_not eq(nil)
  end

  describe "when loading the config" do
    it "should not load if already loaded" do
      File.stub(:exist?){true}
      File.stub(:directory?){true}
      Yolo::Config::Settings.instance.should_not_receive(:load_config)
      Yolo::Config::Settings.instance.check_config
    end

    it "should load if not loaded" do
      File.stub(:exist?){false}
      File.stub(:directory?){false}
      Yolo::Config::Settings.instance.should_receive(:load_config)
      Yolo::Config::Settings.instance.check_config
    end

    it "should create the yolo directory" do
      File.stub(:directory?){false}
      FileUtils.should_receive(:mkdir_p).with("test_dir")
      Yolo::Config::Settings.instance.create_yolo_dir
    end

    it "should not create the yolo directory if it exists" do
      File.stub(:directory?){true}
      FileUtils.should_not_receive(:mkdir_p).with("test_dir")
      Yolo::Config::Settings.instance.create_yolo_dir
    end
  end

  describe "when updating the config" do
    before do
      File.stub(:open)
      File.stub(:exist?){true}
      File.stub(:directory?){true}
    end

    it "should add an api token if missing" do
      @yaml = {"deployment" => {"api_token" => nil}}
      YAML.stub(:load_file){@yaml}
      Yolo::Config::Settings.instance.update_config
      @yaml["deployment"]["api_token"].should eq("example")
    end

    it "should add an team token if missing" do
      @yaml = {"deployment" => {"team_token" => nil}}
      YAML.stub(:load_file){@yaml}
      Yolo::Config::Settings.instance.update_config
      @yaml["deployment"]["team_token"].should eq("example")
    end
  end

  describe "when asked for settings" do
    before do
      @yaml = {
        "paths" => {
          "bundle_directory" => "test_directory"
        },
        "deployment" => {
          "url" => "test_url",
          "api_token" => "test_token",
          "team_token" => "test_team_token",
        },
        "mail" => {
          "account" => "test_account",
          "password" => "test_password",
          "port" => "test_port",
          "host" => "test_host",
          "from" => "test_from"
        }
      }
      YAML.stub(:load_file){@yaml}
      Yolo::Config::Settings.instance.load_yaml
    end

    it "should hold a bundle directory" do
      Yolo::Config::Settings.instance.bundle_directory.should eq("test_directory")
    end

    it "should hold a deploy url" do
      Yolo::Config::Settings.instance.deploy_url.should eq("test_url")
    end

    it "should hold a deploy token" do
      Yolo::Config::Settings.instance.api_token.should eq("test_token")
    end

    it "should hold a deploy team token" do
      Yolo::Config::Settings.instance.team_token.should eq("test_team_token")
    end

    it "should hold a mail account" do
      Yolo::Config::Settings.instance.mail_account.should eq("test_account")
    end

    it "should hold a mail password" do
      Yolo::Config::Settings.instance.mail_password.should eq("test_password")
    end

    it "should hold a mail port" do
      Yolo::Config::Settings.instance.mail_port.should eq("test_port")
    end

    it "should hold a mail host" do
      Yolo::Config::Settings.instance.mail_host.should eq("test_host")
    end

    it "should hold a mail from" do
      Yolo::Config::Settings.instance.mail_from.should eq("test_from")
    end
  end
end
