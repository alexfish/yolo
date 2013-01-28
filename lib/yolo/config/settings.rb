require 'singleton'
require 'yaml'
require 'fileutils'

module Yolo
  module Config
    class Settings

      include Singleton

      def initialize
        @formatter = Yolo::Formatters::ProgressFormatter.new
        @error = Yolo::Formatters::ErrorFormatter.new
        check_config
        @yaml = YAML::load_file yaml_path
      end

      def load_config
        create_yolo_dir
        unless File.exist?(yaml_path)
          @formatter.config_created(yaml_path)
          FileUtils.mv(File.dirname(__FILE__) + "/config.yml", yaml_path)
        end
      end

      def bundle_directory
        @yaml["paths"]["bundle_directory"]
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

      def deploy_url
        @yaml["deployment"]["url"] if @yaml["deployment"]["url"] and @yaml["deployment"]["url"] != "http://url.com"
      end

      private

      def check_config
        unless File.directory?(yolo_dir) and File.exist?(yaml_path)
          @error.run_setup
          load_config
          @formatter.setup_complete
        end
      end

      def user_directory
        File.expand_path('~')
      end

      def yaml_path
        "#{user_directory}/.yolo/config.yml"
      end

      def yolo_dir
        "#{user_directory}/.yolo"
      end

      def create_yolo_dir
        unless File.directory?(yolo_dir)
          FileUtils.mkdir_p(yolo_dir)
        end
      end

    end
  end
end
