require "zip/zip"

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
      # @param  opts [Hash] A hash of deployment options
      # @param  block [Block] Block fired on completing
      #
      def deploy(package_path, opts={}, &block)
        response = ""
        @completion_block = block
        @progress_formatter = Yolo::Formatters::ProgressFormatter.new
        @progress_formatter.deploying_ipa(package_path)

        dsym_zip_path = generate_dsym_zip(package_path)

        IO.popen(curl_string(package_path, dsym_zip_path, opts)) do |io|
          begin
            while line = io.readline
              response << line
            end
            if response.length == 0
              @error_formatter.deploy_failed("Upload error")
            end
          rescue EOFError
          end
        end
        upload_complete(response) if response.length > 0
      end

      private

      #
      # Parses the response json and calls the completion block
      # @param  response [String] The request response
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

        url = json["install_url"]

        @completion_block.call(url,nil)
        @progress_formatter.deploy_complete(url,nil)
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
      # Gets the team token defined in the users config.yml
      #
      # @return [String] The deployment team token defined in config.yml
      def team_token
        token = Yolo::Config::Settings.instance.team_token
        unless token
          @error_formatter.no_team_token
          token = ""
        end
        token
      end

      #
      # Returns a notes string from the Release Notes module, empty if none are set
      #
      # @return [String] The release notes
      def notes
        notes = Yolo::Tools::Ios::ReleaseNotes.plaintext
        notes = "No notes provided" unless notes
        notes
      end

      #
      # Generates a zip file containing the dsym folder.
      # The zip file is uploaded to test flight to help with debugging
      # @param package_path The path to the package
      #
      # @return [String] The dSYM zip file location
      def generate_dsym_zip(package_path)
        dsym_path = package_path.sub(%r[\.ipa$],'.app.dSYM')

        dsym_zip = File.path(dsym_path) + ".zip"
        FileUtils.rm dsym_zip, :force => true

        Zip::ZipFile.open(dsym_zip, 'w') do |zipfile|
          Dir["#{dsym_path}/**/**"].reject{|f|f==dsym_zip}.each do |file|
            zipfile.add(file.sub(dsym_path+'/',''),file)
          end
          return dsym_zip
        end

      end

      #
      # Generates the CURL command string for test flight distribution
      # @param package_path The path to the package
      # @param  opts [Hash] The options array
      #
      # @return [String] The CURL command
      def curl_string(package_path, dsym_zip_path, opts)
        string = "curl http://testflightapp.com/api/builds.json -X POST -# "
        string = string + "-F file=@#{package_path} "
        string = string + "-F dsym=@#{dsym_zip_path} "
        string = string + "-F api_token='#{api_token}' " if api_token.length > 0
        string = string + "-F team_token='#{team_token}' " if team_token.length > 0
        string = string + "-F notes='#{notes}' " if notes.length > 0
        string = string + "-F notify=#{notify(opts)} " if opts
        string = string + "-F distribution_lists=#{distribution_lists(opts)}" if opts and distribution_lists(opts).length > 0
        string
      end

    end
  end
end
