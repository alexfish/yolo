require 'spec_helper'
require 'yolo'

describe Yolo::Tools::Github do

  before do
    Yolo::Formatters::ProgressFormatter.any_instance.stub(:puts)
    Yolo::Formatters::ErrorFormatter.any_instance.stub(:puts)
  end

  describe "when initlized" do
    it "should load the token from settings" do
      Yolo::Config::Settings.instance.stub(:github_token){"token"}
      github = Yolo::Tools::Github.new
      github.instance_variable_get(:@token).should_not eq(nil)
    end

    it "should thrown an error if there is no token" do
      Yolo::Config::Settings.instance.stub(:github_token){nil}
      Yolo::Formatters::ErrorFormatter.any_instance.should_receive(:no_github_token)

      github = Yolo::Tools::Github.new
    end
  end

  describe "when releasing" do
    before do
      @git = mock(Yolo::Tools::Git)
      Yolo::Tools::Git.stub(:new){@git}
      @git.stub(:current_branch){"branch"}

      @github = Yolo::Tools::Github.new
      @github.instance_variable_get(:@octokit).stub(:create_release)
    end

    it "should get the current git branch" do
      @github.instance_eval{current_branch}.should eq("branch")
    end

    it "should zip the bundle" do
      @github.instance_variable_get(:@octokit).stub(:upload_asset)
      @github.should_receive(:zip_bundle).with("path")
      @github.upload_bundle("path", "version", "name")
    end
  end

  describe "when generating options" do

    before do
      github = Yolo::Tools::Github.new
      github.stub(:current_branch){"target_commitish"}
      @options = github.instance_eval{options("body", "version")}
    end

    it "should hold a version" do
      @options["name"].should eq("name")
    end

    it "should hold a body" do
      @options["body"].should eq("body")
    end

    it "should hold the target_commitish" do
      @options["target_commitish"].should eq("target_commitish")
    end
  end
end