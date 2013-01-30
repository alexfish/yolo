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
        puts
        generating = "Generating IPA"
        puts bold(generating)
        puts generating.length.times.map {"="}.join
        puts
      end

      def deploying_ipa
        puts
        deploying = "Deploying IPA"
        puts bold(deploying)
        puts deploying.length.times.map {"="}.join
        puts
      end

      def ipa_generated(ipa)
        puts green("IPA saved to: #{ipa}")
      end

      def generating_notes
        puts
        notes = "Generating release notes"
        puts bold(notes)
        puts notes.length.times.map {"="}.join
        puts
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

      def deploy_complete(url,password)
        deployed = "IPA deployed"
        puts bold(deployed)
        puts deployed.length.times.map {"="}.join
        puts
        puts green("URL")
        puts green(url)
        puts
        puts green("Password")
        puts green(password)
        puts
      end
    end
  end
end
