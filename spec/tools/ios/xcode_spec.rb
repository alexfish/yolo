require 'spec_helper'
require 'yolo/tools/ios/Xcode'

describe Yolo::Tools::Ios::Xcode do

  before do
    @xcode = Yolo::Tools::Ios::Xcode.new
  end

  describe "on init" do
    it "should load a prefs file path" do
      @xcode.prefs_plist_path.should_not eq(nil)
    end
  end

end
