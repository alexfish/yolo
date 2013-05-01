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
        # Overrides the superclass build_opts_string method and appends skip code sign command
        # if debug confid is defined
        #
        # @param  additional_opts [Array] an array of additional options for the build command
        #
        # @return [String] the option string with additional options and test output
        # pipe appended if defined
        def build_opts_string(*additional_opts)
          options = build_opts + additional_opts
          if configuration == "Debug" or configuration.nil?
            options = options << "CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO"
          end
          return options.compact.join(" ")
        end

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
