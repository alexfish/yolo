require 'xcodebuild'

module Yolo
  module Formatters
    class ErrorFormatter < XcodeBuild::Formatters::ProgressFormatter

      def info_plist_not_found
        puts red("Can't locate Info.plist")
      end

      def run_setup
        puts red("Setup required, running rake yolo:setup")
      end

      def deployment_class_error(klass)
        puts red("#{klass} is not a valid Class in the Deployment module")
      end

      def deploy_failed(error)
        puts red("There was a problem deploying the ipa: #{error}")
      end

      def no_deploy_url
        puts red("No deploy url found, please specify one in ~/.yolo/config.yml")
      end

      def missing_email_details
        puts red("Can't send mail notification, missing details")
      end

      def no_notes(notes)
        puts red("No release notes found in the current directory: #{notes}")
      end

    end
  end
end
