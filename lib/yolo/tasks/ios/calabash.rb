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
        # The device to run the tests on
        attr_accessor :device

        #
        # Initializes the class with default settings
        #
        def initialize
          self.sdk = "iphonesimulator" unless sdk
          self.format = :junit
          self.device = "iphone"
          self.output_dir = "test-reports/calabash"
        end

        #
        # Defines rake tasks available to the Calabash class
        #
        def define
          super
          namespace :yolo do
            namespace :calabash do
              desc "Runs the specified scheme(s) calabash tests."
              task :test do
                xcodebuild :clean
                xcodebuild :build
                Yolo::Tools::Ios::Calabash.run(format, output_dir, device)
              end
            end
          end
        end
      end
    end
  end
end
