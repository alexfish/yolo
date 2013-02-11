require 'find'

module Yolo
  module Tasks
    module Ios
      #
      # Executes all release related tasks
      #
      # @author [Alex Fish]
      #
      class Release < Yolo::Tasks::BaseTask

        # The email addresses used when notifying
        attr_accessor :mail_to
        # The deployment class to use when deploying
        attr_accessor :deployment
        # A Hash of additional options
        attr_accessor :options

        #
        # Initializes the class with default settings
        #
        def initialize
          self.sdk = "iphoneos" unless sdk
          self.deployment = :OTA
          @error_formatter = Yolo::Formatters::ErrorFormatter.new
          @emailer = Yolo::Notify::Ios::OTAEmail.new
          @xcode = Yolo::Tools::Ios::Xcode.new
          @bundle_directory = Yolo::Config::Settings.instance.bundle_directory
          super
        end

        #
        # Uses Xcode to find the full path to generated app file
        #
        # @return [String] the path to the generated .app file
        def app_path
          files = []
          Find.find(@xcode.build_path) do |path|
            files << path if path =~ /.*#{name}-.*\/Build\/Products\/.*-iphoneos\/.*\.app$/
          end
          files.sort_by { |filename| File.mtime(filename)}.last # get the latest
        end

        #
        # The name to use for folders etc taken from the scheme or target name
        #
        # @return [String] a name
        def name
          self.scheme ? self.scheme : self.target
        end

        #
        # The path to the applications dSYM folder, the dSYM path is calculated by
        # manipulating the app_path
        #
        # @return [String] the full path to the dSYM folder
        def dsym_path
          paths = app_path.split("/")
          app_file = paths.last
          paths.pop
          path = paths.join("/")
          "#{path}/#{app_file}.dSYM"
        end

        #
        # The full path used when saving files for the build, the path is created
        # using the bundle_directory, folder_name and version methods combined into
        # a single path
        #
        # @return [String] the path to save bundle files to
        def bundle_path
          "#{@bundle_directory}/#{folder_name}/#{version}"
        end

        #
        # The folder name to use for the build bundle directory, the name is created
        # using the relevant scheme and build configuration
        #
        # @return [String] a folder name used in the bundle path
        def folder_name
          folder_name = name
          folder_name = "#{name}-#{self.configuration}" if self.configuration
        end

        #
        # The path to the info-plist file, the method persumes that the command is
        # being called from the directory which contains the plist
        #
        # @return [String] the full path to the projects plist file
        def info_plist_path
          plist_path = ""
          Find.find(Dir.pwd) do |path|
            plist_path = path if path =~ /#{name}-Info.plist$/
          end
          plist_path
        end

        #
        # The version string of the built application
        # if the version number can not be retrieved from Xcode the current date
        # time will be used
        #
        # @return [String] the applications version number
        def version
          @xcode.info_plist_path = info_plist_path
          folder = ""
          folder << @xcode.version_number if @xcode.version_number
          folder << "-#{@xcode.build_number}" if @xcode.build_number
          if folder.length == 0
            time = Time.now
            folder = "#{time.day}-#{time.month}-#{time.year}-#{time.hour}-#{time.min}-#{time.sec}"
          end
          folder
        end

        #
        # Deploys the ipa using the defined deployment strategy, the deployment class is
        # created using the deployment variable as the class name so it is crucial the correct
        # class is in the project.
        #
        # Once deploy is succesful this method will also trigger an email notification using the
        # OTAEmail class
        #
        # @param  ipa_path [String] The full path to the IPA file to deploy
        #
        def deploy(ipa_path)
          klass = Object.const_get("Yolo").const_get("Deployment").const_get("#{self.deployment.to_s}").new
          unless klass
            @error_formatter.deployment_class_error(self.deployment.to_s)
            return
          end

          klass.deploy(ipa_path, options) do |url, password|
            if url
              mail_options = {
                :to => self.mail_to,
                :ota_url => url,
                :subject => "New #{name} build: #{version}",
                :title => name
              }
              mail_options[:ota_password] = password if password
              @emailer.send(mail_options)
            end
          end
        end

        #
        # Defines the rake tasks available to the class
        #
        def define
          super
          namespace :yolo do
            namespace :release do
              desc "Builds and packages a release ipa of specified scheme."
              task :ipa => :build do
                Yolo::Tools::Ios::IPA.generate(app_path,dsym_path,bundle_path) do |ipa|
                  deploy(ipa) if ipa and self.deployment
                end
              end

              desc "Builds and packages a release build for the newest git tag"
              task :tag do
                git = Yolo::Tools::Git.new
                if git.has_new_tag(name)
                  Rake::Task["yolo:release:ipa"].invoke
                end
              end

              desc "Builds and packages a release build for the newest commit"
              task :commit do
                git = Yolo::Tools::Git.new
                if git.has_new_commit(name)
                  Rake::Task["yolo:release:ipa"].invoke
                end
              end

              desc "Generates a release notes file"
              task :notes do
                Yolo::Tools::Ios::ReleaseNotes.generate(info_plist_path)
              end

              desc "Builds the specified release scheme."
              task :build do
                xcodebuild :build
              end
            end
          end
        end
      end
    end
  end
end
