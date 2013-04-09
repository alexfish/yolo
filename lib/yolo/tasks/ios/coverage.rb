module Yolo
  module Tasks
    module Ios
      #
      # Executes all code coverage related tasks
      #
      # @author [Alex Fish]
      #
      class Coverage < Yolo::Tasks::BaseTask
        #
        # Defines rake tasks available to the Coverage class
        #
        def define
          super
          namespace :yolo do
            namespace :coverage do
              desc "Builds the specified scheme(s)."
              task :build => :clean do
                xcodebuild :build
              end

              desc "Calculates the specified scheme(s) test coverage."
              task :calculate => :build do

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
end
