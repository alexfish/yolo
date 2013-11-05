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
      github.instance_variable_get(:@octokit).should_not eq(nil)
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
    end

    it "should get the current git branch" do
      @github.instance_eval{current_branch}.should eq("branch")
    end
  end

  describe "when generating options" do

    before do
      github = Yolo::Tools::Github.new
      github.stub(:current_branch){"branch"}
      @options = github.instance_eval{options("body", "version")}
    end

    it "should hold a version" do
      @options[:name].should eq("version")
    end

    it "should hold a body" do
      @options[:body].should eq("body")
    end

    it "should hold the target_commitish" do
      @options[:target_commitish].should eq("branch")
    end
  end
end