module Yolo
  module Deployment
    class BaseDeployer

      attr_accessor :url
      attr_accessor :ipa_path

      def initialize
        self.url = Yolo::Config::Settings.instance.deploy_url
      end

    end
  end
end
