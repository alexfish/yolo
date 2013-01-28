require 'xcodebuild'

module Yolo
  module Formatters
    class ProgressFormatter < XcodeBuild::Formatters::ProgressFormatter

      def config_created(config)
        puts yellow("Config file created in: #{config}")
      end

      def setup_complete
        puts green("Setup complete")
      end

      def generating_ipa
        puts bold("Generating IPA")
      end

      def deploying_ipa
        puts bold("Deploying IPA")
      end

      def ipa_generated(ipa)
        puts green("IPA saved to: #{ipa}")
      end

      def generating_notes
        puts bold("Generating release notes")
      end

      def notes_generated(notes)
        puts green("Release notes generated")
      end

      def new_tag(tag)
        puts cyan("Found new tag: #{tag}")
      end

      def new_commit(commit)
        puts cyan("Found new commit: #{commit}")
      end

      def no_new_commit
        puts red("No new commit found")
      end

      def no_new_tag
        puts red("No new tag found")
      end

      def deploy_complete
        puts green("IPA deployed")
      end
    end
  end
end
