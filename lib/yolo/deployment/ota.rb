require 'json'

module Yolo
  module Deployment

    #
    # Deploys IPA's using ustwo's OTA
    #
    # @author [Alex Fish]
    #
    class OTA < Yolo::Deployment::BaseDeployer

      #
      # Creates a new OTA instance
      #
      # @return [OTA] A new OTA deployer instance
      def initialize
        @error_formatter = Yolo::Formatters::ErrorFormatter.new
        @progress_formatter = Yolo::Formatters::ProgressFormatter.new
        super
      end


      #
      # Overides the super deploy method
      # @param  package_path [String] A full path to the package to deploy
      # @param  opts [Hash] A hash of deployment options
      # @param  block [Block] Block fired on completing
      #
      def deploy(package_path, opts={}, &block)
        self.package_path = package_path
        @complete_block = block

        unless self.url
          @error_formatter.no_deploy_url
          return
        end

        @progress_formatter.deploying_ipa(self.package_path)

        upload
      end

      #
      # Creates a json package for the OTA uploader params
      #
      # @return [String] A JSON string package
      def package
        filename = self.package_path.split("/").last
        "{\"fileName\": \"#{filename}\", \"password\": \"\", \"validUntil\": \"2000000000\"}"
      end

      #
      # Uploades the package using CURL
      #
      def upload
        response = ""
        IO.popen("curl #{self.url} -X POST -# -F fileContent=@\"#{self.package_path}\" -F params='#{package}'") do |io|
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
      # Method called when the upload is complete, parses the json response form OTA which contains the package url and password
      # @param  response [String] The OTA servers response
      #
      def upload_complete(response)
        json = nil
        begin
          json = JSON.parse(response)
        rescue JSON::ParserError
          @error_formatter.deploy_failed("\n  ParserError: Deployment server response is not JSON")
          return
        end

        unless json
          @error_formatter.deploy_failed("\n  ParserError: Deployment server response is not JSON")
          return
        end

        url = json["link"]
        password = json["password"]

        @complete_block.call(url,password)
        @progress_formatter.deploy_complete(url,password)
      end

    end
  end
end

