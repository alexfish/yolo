require 'spec_helper'

describe Yolo::Deployment::BaseDeployer do

  describe "when initilized" do
    it "should load a deploy url from settings" do
      Yolo::Config::Settings.instance.stub(:deploy_url){"test_url"}
      @deployer = Yolo::Deployment::BaseDeployer.new
      @deployer.url.should eq("test_url")
    end
  end

end
