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
            files << path if path =~ /.*#{name}-.*\/Build\/Intermediates\/#{name}.build\/.*-iphonesimulator\/#{name}.build\/Objects-normal/
          end
          latest = files.sort_by { |filename| File.mtime(filename)}.last # get the latest
          latest.split("/")[0..-2].join("/") # remove the file and get the dir
        end

        #
        # Defines rake tasks available to the Coverage class
        #
        def define
          super
          namespace :yolo do
            namespace :coverage do
              desc "Calculates the specified scheme(s) test coverage."
              task :calculate do
                Yolo::Tools::Ios::Coverage.calculate(build_path.gsub(" ", "\\ "), Dir.pwd)
              end
            end
          end
        end
      end
    end
  end
end
