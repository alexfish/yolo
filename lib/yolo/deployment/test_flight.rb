module Yolo
  module Deployment

    #
    # Deploys IPA's using testflight
    #
    # @author [Alex Fish]
    #
    class TestFlight < Yolo::Deployment::BaseDeployer

      #
      # Overides the super deploy method
      # @param  package_path [String] A full path to the package to deploy
      # @param  dsym_path [String] A full path to the package dsym
      # @param  opts [Hash] A hash of deployment options
      # @param  block [Block] Block fired on completing
      #
      def deploy(package_path, dsym_path, opts={}, &block)
        response = ""
        IO.popen(curl_string(package_path, dsym_path, opts)) do |io|
          begin
            while line = io.readline
              begin
                response << line
              rescue StandardError => e
                 @error_formatter.deploy_failed("ParserError: #{e}")
              end
            end
          rescue EOFError
            #@error_formatter.deploy_failed("ParserError")
           end
        end
        block.call()
      end

      private

      #
      # Parses the deploy options and returns a token if one is found
      # @param  opts [Hash] The options hash
      #
      # @return [String] The team token defined in the deploy options
      def team_token(opts)
        @token = ""
        @token = opts[:team_token] if opts[:team_token]
        @token
      end

      #
      # Parses the deploy options and returns a string for use in curl
      # @param  opts [Hash] The options hash
      #
      # @return [String] A comma seperated string of distribution lists
      def distribution_lists(opts)
        @lists = ""
        if opts[:distribution_lists]
          @lists = opts[:distribution_lists].join(",")
        end
        @lists
      end

      #
      # Parses the options and return a notify string for use in curl
      # @param  opts [Hash] The deployment options hash
      #
      # @return [String] True or False depending on the options
      def notify(opts)
        @notify = false
        if opts[:notify]
          @notify = opts[:notify].to_s.capitalize
        end
        @notify
      end

      #
      # Gets the api token defined in the users config.yml
      #
      # @return [String] The deployment API token defined in config.yml
      def api_token
        token = Yolo::Config::Settings.instance.api_token
        unless token
          @error_formatter.no_api_token
          token = ""
        end
        token
      end

      #
      # Returns a notes string from the Release Notes module, empty if none are set
      #
      # @return [String] The release notes
      def notes
        notes = Yolo::Tools::Ios::ReleaseNotes.html
        notes = "No notes provided" unless notes
        notes
      end

      #
      # Generates the CURL command string for test flight distribution
      # @param  opts [Hash] The options array
      #
      # @return [String] The CURL command
      def curl_string(package_path, dsym_path, opts)
        "curl -X POST http://testflightapp.com/api/builds.json -F file=@#{package_path} -F dsym=@#{dsym_path} -F api_token=#{api_token} -F team_token=#{team_token(opts)} -F notes=#{notes} -F notify=#{notify(opts)} -F distribution_lists=#{distribution_lists(opts)}"
      end

    end
  end
end
