require 'spec_helper'
require 'yolo'

describe Yolo::Tools::Git do

  before do
    @git = Yolo::Tools::Git.new
    @git.project_name = "test"
    YAML.stub!(:load_file){{}}
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

  describe "when updating tags and commits" do

    before do
      @git.stub(:save_yaml)
    end

    it "should keep track of the latest tag" do
      @git.instance_eval{update_tag("new tag")}
      @git.tag.should match("new tag")
    end

    it "should keep track of the latest commit" do
      @git.instance_eval{update_commit("new commit")}
      @git.commit.should match("new commit")
    end

    it "should store the latest tag" do
      @git.instance_eval{update_tag("new tag")}
      @git.instance_eval{yaml_tag}.should match("new tag")
    end

    it "should store the latest commit" do
      @git.instance_eval{update_commit("new commit")}
      @git.instance_eval{yaml_commit}.should match("new commit")
    end

  end

  describe "when saving data" do
    it "should save data to disk" do
      test_file = mock(File)
      test_file.stub(:write)
      File.stub(:open).and_yield(test_file)
      test_file.should_receive(:write)

      @git.instance_eval{save_yaml}
    end
  end

  describe "when checking for new data" do

    it "should use git log" do
      @git.should_receive(:`).with(/git log/)
      @git.instance_eval{log}
    end

    it "should get the latest tag" do
      @git.stub(:log){"tag: v1.0, head, tag: v1.3.1, master"}
      @git.instance_eval{latest_tag}.should eq("v1.0")
    end

    it "should ignore jenkins tags" do
      @git.stub(:log){"tag: jenkins-tag, head, tag: v1.3.1, master"}
      @git.instance_eval{latest_tag}.should_not eq("jenkins-tag")
      @git.instance_eval{latest_tag}.should eq("v1.3.1")
    end

    it "should recognise invalid tags" do
      @git.stub(:log){"junk"}
      @git.instance_eval{latest_tag}.should eq("")
    end

    it "should get the latest commit" do
      @git.stub(:log){"0e4672b678"}
      @git.instance_eval{latest_commit}.should eq("0e4672b678")
    end

    it "should recognise invalid commits" do
      @git.stub(:log){"junk"}
      @git.instance_eval{latest_commit}.should eq("")
    end

    it "should get the current branch" do
      @git.stub(:`){
        "branch\n* activebranch"
      }
      @git.instance_eval{current_branch}.should eq("activebranch")
    end
  end
end
