require 'singleton'
require 'yaml'
require 'fileutils'

module Yolo
  module Config
    class Settings

      include Singleton

      def initialize
        formatter = Yolo::Formatters::ProgressFormatter.new
        create_yolo_dir
        unless File.exist?(yaml_path)
          formatter.config_created(yaml_path)
          FileUtils.mv(File.dirname(__FILE__) + "/config.yml", yaml_path)
        end
        @yaml = YAML::load_file yaml_path
      end

      def bundle_directory
        @yaml["paths"]["bundle_directory"]
      end

      private

      def user_directory
        File.expand_path('~')
      end

      def yaml_path
        "#{user_directory}/.yolo/config.yml"
      end

      def create_yolo_dir
        dir = "#{user_directory}/.yolo"
        unless File.directory?(dir)
          FileUtils.mkdir_p(dir)
        end
      end

    end
  end
end
