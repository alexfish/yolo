require 'singleton'
require 'yaml'
require 'fileutils'

module Yolo
  module Config
    class Settings

      include Singleton

      def initialize
        user_directory = File.expand_path('~')
        yaml_path = "#{user_directory}/.yolo.yml"
        unless File.exist?("#{user_directory}/.yolo.yml")
          puts "moving file"
          FileUtils.mv(File.dirname(__FILE__) + "/.yolo.yml", yaml_path)
        end
        @yaml = YAML::load_file yaml_path
      end

      def ipa_directory
        @yaml["settings"]["ipa_directory"]
      end

      def build_directory
        @yaml["settings"]["build_directory"]
      end

    end
  end
end
