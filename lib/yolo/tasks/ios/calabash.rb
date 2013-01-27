module Yolo
  module Tasks
    module Ios
      class Calabash < Yolo::Tasks::BaseTask

        attr_accessor :format
        attr_accessor :output_dir

        def initialize
          self.sdk = "iphonesimulator" unless sdk
          self.format = :junit
          self.output_dir = "test-reports/calabash"
          super
        end

        def define
          super
          namespace :yolo do
            namespace :calabash do
              desc "Runs the specified target(s) calabash tests."
              task :test do
                Yolo::Tools::Ios::Calabash.run(format, output_dir)
              end

              desc "Cleans the specified target(s)."
              task :clean do
                xcodebuild :clean
              end

              desc "Runs the specified target(s) calabash tests from a clean slate."
              task :cleantest => [:clean, :test]
            end
          end
        end
      end
    end
  end
end
