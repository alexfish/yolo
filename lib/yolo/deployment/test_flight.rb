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
      # @param  block [Block] Block fired on completing
      #
      def deploy(package_path, dsym_path, &block)
        puts "deploying"

        response = ""
        IO.popen("curl -s http://testflightapp.com/api/builds.json
          -F file=@#{package_path}
          -F dsym=@#{dsym_path}
          -F api_token='your_api_token'
          -F team_token='your_team_token'
          -F notes='This build was uploaded via the upload API'
          -F notify=True
          -F distribution_lists='Internal, QA'
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
    end
  end
end
