require 'rake/tasklib'
require 'xcodebuild'
require 'find'

module Yolo
  module Tasks
    module Ios
      class Release < XcodeBuild::Tasks::BuildTask

        attr_accessor :provisioning_profile
        attr_accessor :ipa_directory
        attr_accessor :archive_directory

        def initialize
          self.sdk = "iphoneos" unless sdk
          self.ipa_directory = Yolo::Config::Settings.instance.ipa_directory
          self.archive_directory = Yolo::Config::Settings.instance.archive_directory
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

        def define
          namespace :yolo do
            namespace :release do
              desc "Builds and packages a release ipa of specified scheme."
              task :ipa => :build do
                Yolo::Tools::Ios::IPA.generate(app_path,ipa_directory)
              end

              desc "Builds and packages a release ipa and archive of specified scheme"
              task :ipaandarchive => :ipa do
                #generate an archive and save to archive path
              end

              desc "Builds and packages a release build for the newest git tag"
              task :tag do
                # check for new tag and then build
              end

              desc "Builds and packages a release build for the newest commit"
              task :commit do
                # check for new commit and then build
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
