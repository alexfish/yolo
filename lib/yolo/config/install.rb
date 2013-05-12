require 'fileutils'
require 'yolo/formatters'

module Yolo
  module Config
    #
    # The Install class provides a number of methods to install yolo into projects
    #
    # @author [Alex Fish]
    #
    class Install

      #
      # Runs the yolo project install
      #
      def self.run
         self.move_rakefile
         self.rename_rakefile
         `open Rakefile`
         Yolo::Formatters::ProgressFormatter.new.rakefile_created(Dir.pwd + "/Rakefile")
      end

      private

      #
      # Moves the default rakefile into the current directory
      #
      def self.move_rakefile
         FileUtils.cp_r(self.rakefile, Dir.pwd)
      end

      #
      # The path to the default rake file
      #
      # @return [String] The full path to the default rakefile
      def self.rakefile
        File.dirname(__FILE__) + "/yolo-Rakefile"
      end

      #
      # Renames the default rakefile removing the yolo- prefix
      #
      def self.rename_rakefile
        FileUtils.mv(Dir.pwd + '/yolo-Rakefile',Dir.pwd + '/Rakefile')
      end

    end

  end
end
