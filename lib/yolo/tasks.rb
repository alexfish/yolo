module Yolo
  #
  # The tasks module contains classes which run tasks such as build, release & test
  #
  # @author [Alex Fish]
  #
  module Tasks
  end
end

require 'yolo/tasks/base_task'
require 'yolo/tasks/ios/build'
require 'yolo/tasks/ios/release'
require 'yolo/tasks/ios/ocunit'
require 'yolo/tasks/ios/calabash'
