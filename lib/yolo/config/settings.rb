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

      def mail_host
        @yaml["mail"]["host"] if @yaml["mail"]["host"] and @yaml["mail"]["host"] != "your.server.ip"
      end

      def mail_to
        @yaml["mail"]["to"] if @yaml["mail"]["to"] and @yaml["mail"]["to"] != "example@example.com"
      end

      def mail_from
        @yaml["mail"]["from"] if @yaml["mail"]["from"] and @yaml["mail"]["from"] != "example@example.com"
      end

    end
  end
end
