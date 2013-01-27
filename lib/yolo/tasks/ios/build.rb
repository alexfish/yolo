require 'rake/tasklib'
require 'xcodebuild'

module Yolo
  module Tasks
    module Ios
      class Build < XcodeBuild::Tasks::BuildTask
        def define
          namespace :yolo do
            desc "Builds the specified target(s)."
            task :build do
              xcodebuild :build
            end

            desc "Cleans the specified target(s)."
            task :clean do
              xcodebuild :clean
            end

            desc "Builds the specified target(s) from a clean slate."
            task :cleanbuild => [:clean, :build]
          end
        end
      end
    end
  end
end
