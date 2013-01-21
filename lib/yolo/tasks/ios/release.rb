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
              desc "Builds a and packages a release build of specified target(s)."
              task :release => :build do
                #implement ipa packaking logic
                puts "Doing release.."
              end

              desc "Builds a release build of specified target(s)."
              task :build do
                xcodebuild :build
              end
            end
          end
        end
      end
    end
  end
end
