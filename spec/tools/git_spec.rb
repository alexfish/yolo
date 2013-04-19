require 'yolo/tools/git'
require 'yolo/formatters'

describe Yolo::Tools::Git do

  before do
    @git = Yolo::Tools::Git.new
    Yolo::Formatters::ProgressFormatter.any_instance.stub(:puts)
  end

  describe "when checking for new commits" do
    before do
      @git.stub(:update_commit)
    end

    it "should recognise new commits" do
      Yolo::Tools::Git.any_instance.stub(:yaml_commit){"new"}
      Yolo::Tools::Git.any_instance.stub(:latest_commit){"old"}
      @git.has_new_commit("").should eq(true)
    end

    it "should recognise existing commits" do
      Yolo::Tools::Git.any_instance.stub(:yaml_commit){"old"}
      Yolo::Tools::Git.any_instance.stub(:latest_commit){"old"}
      @git.has_new_commit("").should eq(false)
    end
  end

  describe "when checking for new tags" do
    before do
      @git.stub(:update_tag)
    end

    it "should recognise new tags" do
      Yolo::Tools::Git.any_instance.stub(:yaml_tag){"old"}
      Yolo::Tools::Git.any_instance.stub(:latest_tag){"new"}
      @git.has_new_tag("").should eq(true)
    end

    it "should recognise existing tags" do
      Yolo::Tools::Git.any_instance.stub(:yaml_tag){"old"}
      Yolo::Tools::Git.any_instance.stub(:latest_tag){"old"}
      @git.has_new_tag("").should eq(false)
    end
  end

  pending "should keep track of the latest tag" do
  end

  pending "should keep track of the latest commit" do
  end

  pending "should store the latest tag" do
  end

  pending "should store the latest commit" do
  end

  pending "should save data to disk" do
  end

  pending "should get the latest tag" do
  end

  pending "should get the latest commit" do
  end

  pending "should get the current branch" do
  end
end
