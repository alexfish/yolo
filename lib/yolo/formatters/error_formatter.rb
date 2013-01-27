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

    end
  end
end
