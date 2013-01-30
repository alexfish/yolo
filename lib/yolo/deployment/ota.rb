require 'json'

module Yolo
  module Deployment
    class OTA < Yolo::Deployment::BaseDeployer

      def initialize
        @error_formatter = Yolo::Formatters::ErrorFormatter.new
        @progress_formatter = Yolo::Formatters::ProgressFormatter.new
        super
      end

      def deploy(ipa_path, &block)
        self.ipa_path = ipa_path
        @complete_block = block

        unless self.url
          @error_formatter.no_deploy_url
          return
        end

        @progress_formatter.deploying_ipa

        upload
      end

      def package
        filename = self.ipa_path.split("/").last
        "{\"fileName\": \"#{filename}\", \"password\": \"\", \"validUntil\": \"2000000000\"}"
      end

      def upload
        response = ""
        IO.popen("curl -s #{self.url} -X POST -F fileContent=@\"#{self.ipa_path}\" -F params='#{package}'") do |io|
          begin
            while line = io.readline
              begin
                response << line
              rescue StandardError => e
                 @error_formatter.deploy_failed("ParserError")
              end
            end
          rescue EOFError
            #@error_formatter.deploy_failed("ParserError")
          end
        end
        upload_complete(response)
      end

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

