require 'xcodebuild'

module Yolo
  module Formatters
    class ProgressFormatter < XcodeBuild::Formatters::ProgressFormatter

      def generating_ipa
        puts "Generating IPA"
      end

      def ipa_generated(ipa)
        puts green("IPA saved to: #{ipa}")
      end

    end
  end
end
