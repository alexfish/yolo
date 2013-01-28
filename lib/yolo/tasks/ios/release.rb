require 'find'

module Yolo
  module Tasks
    module Ios
      class Release < Yolo::Tasks::BaseTask

        attr_accessor :bundle_directory
        attr_accessor :mail_to
        attr_accessor :deployment

        def initialize
          self.sdk = "iphoneos" unless sdk
          self.bundle_directory = Yolo::Config::Settings.instance.bundle_directory
          super
        end

        def app_path
          xcode = Yolo::Tools::Ios::Xcode.new
          files = []
          Find.find(xcode.build_path) do |path|
            files << path if path =~ /.*#{name}-.*\/Build\/Products\/.*-iphoneos\/.*\.app$/
          end
          files.sort_by { |filename| File.mtime(filename)}.last # get the latest
        end

        def name
          self.scheme ? self.scheme : self.target
        end

        def dsym_path
          paths = app_path.split("/")
          app_file = paths.last
          paths.pop
          path = paths.join("/")
          "#{path}/#{app_file}.dSYM"
        end

        def info_plist_path
          plist_path = ""
          Find.find(Dir.pwd) do |path|
            plist_path = path if path =~ /#{name}-Info.plist$/
          end
          plist_path
        end

        def version_folder
          xcode = Yolo::Tools::Ios::Xcode.new
          xcode.info_plist_path = info_plist_path
          folder = ""
          folder << xcode.version_number if xcode.version_number
          folder << "-#{xcode.build_number}" if xcode.build_number
          if folder.length == 0
            time = Time.now
            folder = "#{time.year}-#{time.month}-#{time.year}-#{time.hour}-#{time.min}-#{time.sec}"
          end
          folder
        end

        def define
          super
          namespace :yolo do
            namespace :release do
              desc "Builds and packages a release ipa of specified scheme."
              task :ipa => :build do
                self.bundle_directory = "#{bundle_directory}/#{name}/#{version_folder}"
                Yolo::Tools::Ios::IPA.generate(app_path,bundle_directory)
              end

              desc "Builds and packages a release ipa and archive of specified scheme"
              task :ipaandarchive => :ipa do
                #generate an archive and save to archive path
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
            end

            desc "Builds a release build of specified scheme."
            task :build do
              xcodebuild :build
            end
          end
        end
      end
    end
  end
end
