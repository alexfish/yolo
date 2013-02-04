module Yolo
  module Deployment

    #
    # Deploys IPA's using testflight
    #
    # @author [Alex Fish]
    #
    class TestFlight < Yolo::Deployment::BaseDeployer

      def deploy(package_path, &block)
        puts "deploying"
        block.call
      end

    end
  end
end
