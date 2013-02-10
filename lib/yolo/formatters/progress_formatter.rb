require 'xcodebuild'

module Yolo
  module Formatters
    #
    # Outputs formatted progress messages to the console
    #
    # @author [Alex Fish]
    #
    class ProgressFormatter < XcodeBuild::Formatters::ProgressFormatter

      #
      # Outputs a green string stating that the config file was created
      # @param  config [String] The path to the config file
      #
      def config_created(config)
        puts green("Config file created in: #{config}")
      end

      #
      # Outputs a green string stating that setup is complete
      #
      def setup_complete
        puts green("Setup complete")
      end

      #
      # Outputs a green string stating that the config file was updated
      # @param  config [String] The path to the config file
      #
      def config_updated(config)
        puts green("Config updated at: #{config}")
      end

      #
      # Outputs an underlined bold string stating that the ipa is being generated
      #
      def generating_ipa
        puts
        generating = "Generating IPA"
        puts bold(generating)
        puts generating.length.times.map {"="}.join
        puts
      end

      #
      # Outputs an underlined bold string stating the ipa is being deployed and it's file size
      # @param  ipa [String] The path to the ipa being deployred
      #
      def deploying_ipa(ipa)
        puts
        deploying = "Deploying IPA"
        puts bold(deploying)
        puts deploying.length.times.map {"="}.join
        puts
        puts ("#{filesize(ipa)}MB")
        puts
      end

      #
      # Outputs a green string stating that the ipa was deployed
      # @param  ipa [String] The path to the ipa
      #
      def ipa_generated(ipa)
        puts green("IPA saved to: #{ipa}")
      end

      #
      # Outputs an underlined bold string stating that the release notes are being generated
      #
      def generating_notes
        puts
        notes = "Generating release notes"
        puts bold(notes)
        puts notes.length.times.map {"="}.join
        puts
      end

      #
      # Outputs a green string stating that the release notes have been generated
      # @param  notes [String] The path to the release notes
      #
      def notes_generated(notes)
        puts green("Release notes generated: #{notes}")
      end

      #
      # Outputs a cyan string stating that a new tag has been found
      # @param  tag [String] The tag
      #
      def new_tag(tag)
        puts cyan("Found new tag: #{tag}")
      end

      #
      # Outputs a cyan string stating that a new commit has been found
      # @param  commit [String] The commit hash
      #
      def new_commit(commit)
        puts cyan("Found new commit: #{commit}")
      end

      #
      # Outputs a red string stating that no new commit was found
      #
      def no_new_commit
        puts red("No new commit found")
      end

      #
      # Outputs a red string stating that no new tag was found
      #
      def no_new_tag
        puts red("No new tag found")
      end

      #
      # Outputs an underlined bold string stating that the notification email is being sent
      #
      def sending_email
        puts
        email = "Sending notification email"
        puts bold(email)
        puts email.length.times.map {"="}.join
        puts
      end

      #
      # Outputs a green string stating the email was sent
      # @param  to [Array] the users the email was sent to
      #
      def email_sent(to)
        puts green("Notification sent to: #{to}")
      end

      #
      # Outputs a formatted string stating that the OTA deploy is complete
      # @param  url [String] The URL to the deployed Application
      # @param  password [String] The password for the deployed application
      #
      def deploy_complete(url,password)
        puts
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

      #
      # Calculates the size of a file
      # @param  file [String] The full path to the file
      #
      # @return [Number] The size of the file in MBs
      def filesize(file)
        '%.2f' % (File.size(file).to_f / 2**20)
      end
    end
  end
end
