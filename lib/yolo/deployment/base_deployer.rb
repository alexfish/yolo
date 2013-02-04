module Yolo
  module Deployment

    #
    # The Deployment super class
    #
    # @author [Alex Fish]
    #
    class BaseDeployer
      # The deployer's url
      attr_accessor :url
      # The path to the [packge to deploy]
      attr_accessor :package_path

      #
      # Returns a new Deployer instance
      #
      # @return [BaseDeployer] A new BaseDeployer instance
      def initialize
        self.url = Yolo::Config::Settings.instance.deploy_url
      end

      #
      # Deploys the package, all deployer subclasses must implement this method
      # @param  package_path [String] A full path to the package to deploy
      # @param  dsym_path [String] A full path to the package dsym
      # @param  block [Block] Block fired on completing
      #
      def deploy(package_path, dsym_path, &block)
      end

    end
  end
end
