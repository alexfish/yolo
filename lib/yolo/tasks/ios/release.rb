require 'rake/tasklib'
require 'xcodebuild'

module Yolo
  module Tasks
    module Ios
      class Release < XcodeBuild::Tasks::BuildTask

      end
    end
  end
end
