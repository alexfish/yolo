require 'spec_helper'
require 'yolo'

describe Yolo::Tasks::Ios::OCUnit do
  before do
    @ocunit = Yolo::Tasks::Ios::OCUnit.new
  end

  describe "when created" do
    it "should set the iphonesimulator as the default sdk" do
      @ocunit.sdk.should eq("iphonesimulator")
    end

    it "should set junit as the default test output" do
      @ocunit.test_output.should eq(:junit)
    end
  end

  describe "when building an options string" do
    it "should append additional options" do
      @ocunit.build_opts_string("one","two","three").should match(/one two three/)
    end

    it "should pipe output to ocunit2junit" do
      @ocunit.test_output = :junit
      @ocunit.build_opts_string.should match(/2>&1 | ocunit2junit/)
    end
  end
end
