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
      def deploy(package_path, dysm_path, opts={}, &block)
        response = ""
        IO.popen("curl -s http://testflightapp.com/api/builds.json
          -F file=@#{package_path}
          -F dsym=@#{dsym_path}
          -F api_token=@#{api_token}
          -F team_token=@#{opts[:team_token]}
          -F notes=@#{notes}
          -F notify=@#{opts[:notify]}
          -F distribution_lists=@#{opts[:distribution_lists].join(",")}
           ")
        do |io|
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
        upload_complete(response)
      end

      #
      # Gets the api token defined in the users config.yml
      #
      # @return [String] The deployment API token defined in config.yml
      def api_token
        Yolo::Settings::Config.instance.api_token
      end

      #
      # Returns a notes string from the Release Notes module, empty if none are set
      #
      # @return [String] The release notes
      def notes
        notes = Yolo::Tools::Ios::ReleaseNotes.html
        notes = "" unless notes
        notes
      end

    end
  end
end
