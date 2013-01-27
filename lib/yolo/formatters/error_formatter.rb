require 'xcodebuild'

module Yolo
  module Formatters
    class ErrorFormatter < XcodeBuild::Formatters::ProgressFormatter

      def self.info_plist_not_found
        puts red("Can't locate Info.plist")
      end

    end
  end
end
