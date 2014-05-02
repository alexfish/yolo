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

    it "should use the scheme if it is set" do
      scheme = "TEST_SCHEME"
      @ocunit.scheme = scheme
      @ocunit.scheme.should eq(scheme)
    end

    it "should use the scheme env var if no scheme is set" do
      scheme = "TEST_SCHEME"
      ENV['YOLO_OCUNIT_SCHEME'] = scheme
      
      @ocunit.scheme.should eq(scheme)
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
