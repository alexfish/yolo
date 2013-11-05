require 'octokit'

module Yolo
  module Tools
    #
    # Communicates with Github
    #
    # @author [Alex Fish]
    #
    class Github

      # The github repo that all actions will target
      attr_accessor :repo

      #
      # Creates the class with default variables
      #
      def initialize
        token = Yolo::Config::Settings.instance.github_token
        if token
          @octokit = Octokit::Client.new :access_token => token
        else
          error = Yolo::Formatters::ErrorFormatter.new
          error.no_github_token
        end
      end

      # Release the ipa using the github releases API, the ipa will be zipped and
      # uploaded as well as the release notes used as the release body and
      # version for the release title
      #
      # @param  ipa [String] The full path to the IPA file to deploy
      # @param  version [String] The version of the release
      # @param  body [String] The body of the release
      #
      def release(ipa, version, body)
        @octokit.create_release(self.repo, version, options(body, version))
      end

      private

      #
      # Generates an options hash for a github release
      #
      # @return [String] The current branch name
      def options(body, version)
        options = {:body => body, :name => version, :target_commitish => current_branch}
        options
      end

      #
      # Finds the current branch using the git tool
      #
      # @return [String] The current branch name
      def current_branch
        git = Yolo::Tools::Git.new
        git.current_branch
      end

    end
  end
end
