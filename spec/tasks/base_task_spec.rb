require 'spec_helper'
require 'yolo'

describe Yolo::Tasks::BaseTask do

  describe "when returning a name" do
    before do
      @basetask = Yolo::Tasks::BaseTask.new
    end

    it "should return a target name if no scheme is set" do
      @basetask.scheme = nil
      @basetask.target = "TestTarget"
      @basetask.name.should eq("TestTarget")
    end

    it "should return a scheme name if a scheme is set" do
      @basetask.scheme = "TestScheme"
      @basetask.target = nil
      @basetask.name.should eq("TestScheme")
    end
  end
end
