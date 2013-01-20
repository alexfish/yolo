require 'rake/tasklib'
require 'xcodebuild'

module Yolo
  module Tasks
    module Ios
      class Test < XcodeBuild::Tasks::BuildTask

        attr_accessor :test_output
        attr_accessor :format
        attr_accessor :output_dir

        def initialize
          self.sdk = "iphonesimulator" unless sdk
          self.test_output = :junit
          self.format = :junit
          self.output_dir = "test-reports/cucumber"
          super
        end

        def build_opts_string(*additional_opts)
          options = build_opts + additional_opts
          options = options << "2>&1 | ocunit2junit" if test_output == :junit
          return options.compact.join(" ")
        end

        def define
          namespace :yolo do
            namespace :ios do
              desc "Builds the specified target(s)."
              task :test do
                xcodebuild :build
              end

              task :calabash => [:cleantest] do
                Yolo::Tests::Ios::Calabash.run(format, output_dir)
              end

              desc "Cleans the specified target(s)."
              task :clean do
                xcodebuild :clean
              end

              desc "Builds the specified target(s) from a clean slate."
              task :cleantest => [:clean, :test]
            end
          end
        end
      end
    end
  end
end
