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

      # Release the bundle using the github releases API, the bundle will be zipped and
      # uploaded as well as the release notes used as the release body and
      # version for the release title
      #
      # @param  bundle [String] The full path to the bundle folder to release
      # @param  version [String] The version of the release
      # @param  body [String] The body of the release
      #
      def release(bundle, version, body)
        @progress = Yolo::Formatters::ProgressFormatter.new
        @progress.creating_github_release
        response = @octokit.create_release(self.repo, version, options(body, version))
        if response
          upload_url = response["upload_url"]
          upload_bundle(bundle, upload_url)
        end
      end

      # Upload the bundle to the github release url
      #
      # @param  bundle [String] The full path to the bundle folder to release
      # @param  url [String] The github asset url returned from create_release
      #
      def upload_bundle(bundle, url)
        @progress = Yolo::Formatters::ProgressFormatter.new
        @progress.github_uploading
        response = @octokit.upload_asset(url, bundle)
        puts response
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
