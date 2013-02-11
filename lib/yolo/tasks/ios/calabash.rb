module Yolo
  module Tasks
    module Ios
      #
      # Executes all calabash related tasks
      #
      # @author [Alex Fish]
      #
      class Calabash < Yolo::Tasks::BaseTask

        # The test report output format
        attr_accessor :format
        # The directory to output the test reports
        attr_accessor :output_dir

        #
        # Initializes the class with default settings
        #
        def initialize
          self.sdk = "iphonesimulator" unless sdk
          self.format = :junit
          self.output_dir = "test-reports/calabash"
          super
        end

        #
        # Defines rake tasks available to the Calabash class
        #
        def define
          super
          namespace :yolo do
            namespace :calabash do
              desc "Runs the specified scheme(s) calabash tests."
              task :test => :build do
                Yolo::Tools::Ios::Calabash.run(format, output_dir)
              end

              desc "Cleans the specified scheme(s)."
              task :clean do
                xcodebuild :clean
              end

              desc "Builds the specified scheme(s)."
              task :build do
                xcodebuild :build
              end

              desc "Runs the specified scheme(s) calabash tests from a clean slate."
              task :cleantest => [:clean, :test]
            end
          end
        end
      end
    end
  end
end
