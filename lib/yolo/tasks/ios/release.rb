require 'rake/tasklib'
require 'xcodebuild'

module Yolo
  module Tasks
    module Ios
      class Release < XcodeBuild::Tasks::BuildTask

        attr_accessor :provisioning_profile

        def initialize
          self.sdk = "iphonesimulator" unless sdk
          super
        end

        def define
          namespace :yolo do
            namespace :ios do
              desc "Builds a release build of specified target(s)."
              task :release do
                xcodebuild :build
                # generate ipa...
              end
            end
          end
        end
      end
    end
  end
end
