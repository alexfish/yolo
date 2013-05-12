module Yolo
  module Tasks
    module Ios
      #
      # Executes all OCunit related tasks
      #
      # @author [Alex Fish]
      #
      class OCUnit < Yolo::Tasks::BaseTask

        # the test_output type used when running tests, currently only supports
        # :junit
        attr_accessor :test_output

        #
        # Initializes the class with default settings
        #
        def initialize
          self.sdk = "iphonesimulator" unless sdk
          self.test_output = :junit
          super
        end

        #
        # Overrides the superclass build_opts_string method and appends a pipe
        # if test_ouput is defined
        #
        # @param  additional_opts [Array] an array of additional options for the build command
        #
        # @return [String] the option string with additional options and test output
        # pipe appended if defined
        def build_opts_string(*additional_opts)
          options = build_opts + additional_opts
          options = options << "2>&1 | ocunit2junit" if test_output == :junit
          return options.compact.join(" ")
        end

        #
        # Defines rake tasks available to the OCUnit class
        #
        def define
          super
          namespace :yolo do
            namespace :ocunit do
              desc "Runs the specified scheme(s) OCUnit tests."
              task :test do
                xcodebuild :clean
                xcodebuild :build
              end
            end
          end
        end
      end
    end
  end
end
