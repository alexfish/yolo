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

      def generating_notes
        puts "Generating release notes"
      end

      def notes_generated(notes)
        puts green("Release notes generated")
      end

      def new_tag(tag)
        puts green("Found new tag: #{tag}")
      end

      def new_commit(commit)
        puts green("Found new commit: #{commit}")
      end

    end
  end
end
