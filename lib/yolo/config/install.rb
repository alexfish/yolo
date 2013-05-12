require 'fileutils'

module Yolo
  module Config
    #
    # The Install class provides a number of methods to install yolo into projects
    #
    # @author [Alex Fish]
    #
    class Install

      def self.run
         self.move_rakefile
         self.rename_rakefile
      end

      private

      def self.move_rakefile
         FileUtils.cp_r(File.dirname(__FILE__) + "/yolo-Rakefile", Dir.pwd)
      end

      def self.rakefile
        File.dirname(__FILE__) + "/yolo-Rakefile"
      end

      def self.rename_rakefile
        FileUtils.mv(Dir.pwd + '/yolo-Rakefile',Dir.pwd + '/Rakefile')
      end

    end

  end
end
