require 'rake/tasklib'
require 'xcodebuild'

module Yolo
  module Tasks
    class BuildTask < ::Rake::TaskLib
      def initialize
        define
      end

      def define
        namespace :yolo do
          namespace :ios do
            desc "Builds the specified target(s)."
            task :build do
              XcodeBuild::Tasks::BuildTask.new.run(:build)
            end

            task :clean do
              XcodeBuild::Tasks::BuildTask.new.run(:clean)
            end
          end
        end
      end
    end
  end
end
