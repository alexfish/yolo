require 'curb'
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

        upload
      end

      def package
        "{'fileName': '#{self.ipa_path}', 'password': '', 'validUntil': 2000000000}"
      end

      def upload
        @curl = Curl::Easy.http_post(self.url,
                         Curl::PostField.content('fileContent', self.ipa_path),
                         Curl::PostField.content('params', package))
        @curl.on_success {upload_complete}
        @curl.on_failure {upload_failed}
        @curl.perform
      end

      def upload_complete
        response = JSON.parse(@curl.body_str)

        puts response #debug
        url = response["link"]
        password = response["password"]

        @complete_block.call(url,password)
        @progress_formatter.deploy_complete
      end

      def upload_failed
        @error_formatter.deploy_failed
      end

    end
  end
end
