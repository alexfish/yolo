require 'rake/tasklib'
require 'xcodebuild'
require 'find'

module Yolo
  module Tasks
    module Ios
      class Release < XcodeBuild::Tasks::BuildTask

        attr_accessor :provisioning_profile

        def initialize
          self.sdk = "iphoneos" unless sdk
          super
        end

        def app_path
          xcode = Yolo::Tools::Ios::Xcode.new
          name = self.scheme ? self.scheme : self.target
          files = []
          Find.find(xcode.build_path) do |path|
            files << path if path =~ /.*#{name}-.*\/Build\/Products\/.*-iphoneos\/.*\.app$/
          end
          files.sort_by { |filename| File.mtime(filename)}.last # get the newist app
        end

        def define
          namespace :yolo do
            namespace :ios do
              desc "Builds a and packages a release build of specified target(s)."
              task :release => :build do
                #implement ipa packaking logicg
                puts "Doing release.. #{app_path}"
              end

              desc "Builds a release build of specified target(s)."
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
