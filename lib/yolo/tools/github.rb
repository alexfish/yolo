require "zip"
require "net/http"
require "uri"
require 'json'

module Yolo
  module Tools
    #
    # Communicates with Github
    #
    # @author [Alex Fish]
    #
    class Github

      # The github repo that all actions will target
      attr_accessor :repo

      #
      # Creates the class with default variables
      #
      def initialize
        @token = Yolo::Config::Settings.instance.github_token
        if !@token
          error = Yolo::Formatters::ErrorFormatter.new
          error.no_github_token
        end
      end

      # Release the bundle using the github releases API, the bundle will be zipped and
      # uploaded as well as the release notes used as the release body and
      # version for the release title
      #
      # @param  bundle [String] The full path to the bundle folder to release
      # @param  version [String] The version of the release
      # @param  body [String] The body of the release
      #
      def release(bundle, version, body)
        @progress = Yolo::Formatters::ProgressFormatter.new
        @progress.creating_github_release

        uri = URI.parse("https://api.github.com/repos/#{self.repo}/releases?access_token=#{@token}")

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true

        request = Net::HTTP::Post.new(uri.request_uri)
        request.body = options(body, version)

        # Tweak headers, removing this will default to application/x-www-form-urlencoded
        request["Content-Type"] = "application/json"

        response = http.request(request)
        response = JSON.parse(response.body)

        if response.has_key?("upload_url")
          @progress.created_release(version)
          url = response["upload_url"].gsub("{?name}","")
          upload_bundle(bundle, url, "#{version}.zip")
        else
          error = Yolo::Formatters::ErrorFormatter.new
          error.no_github_release
        end
      end

      # Upload the bundle to the github release url
      #
      # @param  bundle [String] The full path to the bundle folder to release
      # @param  url [String] The github asset url returned from create_release
      #
      def upload_bundle(bundle, url, name)
        @progress = Yolo::Formatters::ProgressFormatter.new
        @progress.github_uploading
        zipped_bundle = zip_bundle(bundle)

        response = ""
        curl = curl_string(name, zipped_bundle, url)
        IO.popen(curl) do |io|
          begin
            while line = io.readline
              response << line
            end
            if response.length == 0
              @error_formatter.github_upload_failed("Upload error")
            end
          rescue EOFError
          end
        end

        @progress.github_released
      end

      private

      # Generate a curl command string to upload the release to github with
      #
      # @param name [String] The name of the file
      # @param zipped_bundle [String] The full path to the zipped bundle folder
      # @param url [String] The URL for the request
      #
      # @return [String] The curl command string
      def curl_string(name, zipped_bundle, url)
        "curl -# -H \"Accept: application/vnd.github.manifold-preview\" \
          -H \"Content-Type: application/zip\" \
          --data-binary @#{zipped_bundle} \
          \"#{url}?name=#{name}&access_token=#{@token}\"
          "
      end

      # Zip the bundle ready for upload to github, the zip will have the same
      # name as the bundle folder with .zip appended
      #
      # @param  bundle [String] The full path to the bundle folder to zip
      #
      # @return [String] The zipped bundle path
      def zip_bundle(bundle)
        bundle.sub!(%r[/$],'')
        archive = File.join(bundle,File.basename(bundle))+'.zip'
        FileUtils.rm archive, :force=>true

        Zip::File.open(archive, 'w') do |zipfile|
          Dir["#{bundle}/**/**"].reject{|f|f==archive}.each do |file|
            zipfile.add(file.sub(bundle+'/',''),file)
          end
          return archive
        end
      end

      #
      # Generates an options hash for a github release
      #
      # @return [String] The current branch name
      def options(body, version)
        options = {"body" => body, "tag_name" => version, "name" => version, "target_commitish" => current_branch}
        options.to_json
      end

      #
      # Finds the current branch using the git tool
      #
      # @return [String] The current branch name
      def current_branch
        git = Yolo::Tools::Git.new
        git.current_branch
      end

    end
  end
end
