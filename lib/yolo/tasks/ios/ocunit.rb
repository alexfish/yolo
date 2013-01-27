require 'rake/tasklib'
require 'xcodebuild'

module Yolo
  module Tasks
    module Ios
      class OCUnit < XcodeBuild::Tasks::BuildTask

        attr_accessor :test_output

        def initialize
          self.sdk = "iphonesimulator" unless sdk
          self.test_output = :junit
          super
        end

        def build_opts_string(*additional_opts)
          options = build_opts + additional_opts
          options = options << "2>&1 | ocunit2junit" if test_output == :junit
          return options.compact.join(" ")
        end

        def define
          namespace :yolo do
            namespace :ocunit do
              desc "Runs the specified target(s) OCUnit tests."
              task :test do
                xcodebuild :build
              end

              desc "Cleans the specified target(s)."
              task :clean do
                xcodebuild :clean
              end

              desc "Runs the specified target(s) OCUnit tests from a clean slate."
              task :cleantest => [:clean, :test]
            end
          end
        end
      end
    end
  end
end
