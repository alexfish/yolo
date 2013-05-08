require 'yolo/tasks'
require 'yolo/tools'
require 'active_support/all'
describe Yolo::Tasks::Ios::Coverage do
  before do
    @xcode = mock(Yolo::Tools::Ios::Xcode)
    @xcode.stub(:build_path)
    Yolo::Tools::Ios::Xcode.stub(:new){@xcode}
    @coverage = Yolo::Tasks::Ios::Coverage.new
    @test_path = "blah/name-test/Build/Intermediates/name.build/Debug-iphonesimulator/name.build/Objects-normal"
    @false_path = "blah/name-false/Build/Intermediates/name.build/Debug-iphonesimulator/name.build/Objects-normal"
  end

  describe "when getting a build path" do

    before do
      @coverage.stub(:name){"name"}
    end

    it "should find the directory" do
      Find.stub(:find).and_yield(@test_path)
      File.stub(:mtime){Time.now}
      @coverage.build_path.should eq("blah/name-test/Build/Intermediates/name.build/Debug-iphonesimulator/name.build")
    end

    it "should find the latest directory" do
      Find.stub(:find).and_yield(@test_path).and_yield(@false_path)
      File.stub(:mtime).and_return(Time.now, Time.now - 1.day)
      @coverage.build_path.should eq("blah/name-test/Build/Intermediates/name.build/Debug-iphonesimulator/name.build")
    end
  end
end
