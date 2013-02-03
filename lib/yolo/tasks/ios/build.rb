module Yolo
  module Tasks
    module Ios
      #
      # Executes all build related tasks
      #
      # @author [Alex Fish]
      #
      class Build < Yolo::Tasks::BaseTask
        #
        # Defines rake tasks available to the Build class
        #
        def define
          super
          namespace :yolo do
            desc "Builds the specified scheme(s)."
            task :build do
              xcodebuild :build
            end

            desc "Cleans the specified scheme(s)."
            task :clean do
              xcodebuild :clean
            end

            desc "Builds the specified scheme(s) from a clean slate."
            task :cleanbuild => [:clean, :build]
          end
        end
      end
    end
  end
end
