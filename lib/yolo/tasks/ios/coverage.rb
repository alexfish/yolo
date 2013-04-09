module Yolo
  module Tasks
    module Ios
      #
      # Executes all code coverage related tasks
      #
      # @author [Alex Fish]
      #
      class Coverage < Yolo::Tasks::BaseTask

        #
        # Initializes the class with default settings
        #
        def initialize
          @xcode = Yolo::Tools::Ios::Xcode.new
          super
        end

        #
        # Uses Xcode to find the full path to generated app file
        #
        # @return [String] the path to the generated .app file
        def build_path
          files = []
          Find.find(@xcode.build_path) do |path|
            files << path if path =~ /.*#{name}-.*\/Build\/Intermediates\/#{name}.build\/.*-iphoneos\/#{name}.build\/Objects-normal/
          end
          files.sort_by { |filename| File.mtime(filename)}.last # get the latest
        end

        #
        # Defines rake tasks available to the Coverage class
        #
        def define
          super
          namespace :yolo do
            namespace :coverage do
              desc "Builds the specified scheme(s)."
              task :build => :clean do
                xcodebuild :build
              end

              desc "Calculates the specified scheme(s) test coverage."
              task :calculate => :build do
                Yolo::Tools::Ios::Coverage.calculate(build_path.gsub(" ", "\\ "), Dir.pwd)
              end

              desc "Cleans the specified scheme(s)."
              task :clean do
                xcodebuild :clean
              end

              desc "Builds the specified scheme(s) from a clean slate."
              task :cleanbuild => [:clean, :build]
            end
          end
        end
      end
    end
  end
end
