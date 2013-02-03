require 'xcodebuild'

module Yolo
  module Formatters
    #
    # Outputs formatted error messages to the console
    #
    # @author [Alex Fish]
    #
    class ErrorFormatter < XcodeBuild::Formatters::ProgressFormatter

      #
      # Outputs a red string stating that the info.plist file could not be found
      #
      def info_plist_not_found
        puts red("Can't locate Info.plist")
      end

      #
      # Outputs a red string stating that setup is required
      #
      def run_setup
        puts red("Setup required, running rake yolo:setup")
      end

      #
      # Outputs a red string stating the the deployment class is invalid
      # @param  klass [String] The deployment class name
      #
      def deployment_class_error(klass)
        puts red("#{klass} is not a valid Class in the Deployment module")
      end

      #
      # Outputs a red string stating that there was an issue deploying the ipa
      # @param  error [String] The error string
      #
      def deploy_failed(error)
        puts red("There was a problem deploying the ipa: #{error}")
      end

      #
      # Outputs a red string stating that no deploy URL was found in the config file
      #
      def no_deploy_url
        puts red("No deploy url found, please specify one in ~/.yolo/config.yml")
      end

      #
      # Outputs a red string stating that email notification failed because of missing details
      #
      def missing_email_details
        puts red("Can't send mail notification, missing details")
      end

      #
      # Outputs a red string stating that a release notes file could not be found
      # @param  notes [String] The path which should contain a notes file
      #
      def no_notes(notes)
        puts red("No release notes found in the current directory: #{notes}")
      end

    end
  end
end
