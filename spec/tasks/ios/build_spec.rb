require 'spec_helper'

describe Yolo::Tasks::Ios::Build do
  describe "when building an options string" do
    before do
      @buildtask = Yolo::Tasks::Ios::Build.new
    end

    after do
      @buildtask.configuration = nil
    end

    it "should append any additional options" do
      @buildtask.build_opts_string("one", "two", "three").should match(/one two three/)
    end

    it "should skip code signing if a debug build" do
      @buildtask.configuration = "Debug"
      @buildtask.build_opts_string.should match(/CODE_SIGN_IDENTITY='' CODE_SIGNING_REQUIRED=NO/)
    end
  end
end
