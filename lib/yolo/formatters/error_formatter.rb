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

      def deploy_failed
        puts red("There was a problem deploying the ipa")
      end

    end
  end
end
