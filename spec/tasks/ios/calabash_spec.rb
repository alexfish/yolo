require 'yolo/tasks'

describe Yolo::Tasks::Ios::Calabash do
  before do
    @calabash = Yolo::Tasks::Ios::Calabash.new
  end

  describe "when created" do
    it "should set junit as the default format" do
      @calabash.format.should eq(:junit)
    end

    it "should set the iphonesimulator as the default sdk" do
      @calabash.sdk.should eq("iphonesimulator")
    end

    it "should set test-reports/calabash as the default output directory" do
      @calabash.output_dir.should eq("test-reports/calabash")
    end
  end
end
