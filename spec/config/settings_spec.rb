require 'spec_helper'
require "yolo/config/settings"

describe Yolo::Config::Settings do

  @settings = Yolo::Config::Settings.instance

  it "should be a singleton" do
    Yolo::Config::Settings.instance.should_not eq(nil)
  end

end
