require 'singleton'
require 'yaml'
require 'fileutils'

module Yolo
  module Config
    #
    # The Settings Singleton class provides yolo with a number of configurable settings using a config.yml file written to the users home directory
    #
    # @author [Alex Fish]
    #
    class Settings

      include Singleton

      #
      # Creates a new Settings instance with default settings, also checks for the presence of a settings file in the users home directory
      #
      def initialize
        @formatter = Yolo::Formatters::ProgressFormatter.new
        @error = Yolo::Formatters::ErrorFormatter.new
        check_config
        update_config
      end

      #
      # Loads the @yaml instance var
      #
      def load_yaml
        @yaml = YAML::load_file yaml_path
      end

      #
      # Moves the config.yml settings file into the usrs home directory
      #
      def load_config
        create_yolo_dir
        unless File.exist?(yaml_path)
          @formatter.config_created(yaml_path)
          FileUtils.cp_r(File.dirname(__FILE__) + "/config.yml", yaml_path)
        end
      end

      #
      # Checks for the existance of the config directory in the users home directory and creates it if not present
      #
      def check_config
        unless File.directory?(yolo_dir) and File.exist?(yaml_path)
          @error.run_setup
          load_config
          @formatter.setup_complete
        end
      end

      #
      # Checks the config file is update to the latest and adds any options that are missing
      #
      def update_config
        if File.directory?(yolo_dir) and File.exist?(yaml_path)
          @yaml = YAML::load_file yaml_path
          unless @yaml["deployment"]["api_token"]
            @yaml["deployment"]["api_token"] = "example"
            File.open(yaml_path, 'w') {|f|
              f.write(@yaml.to_yaml)
            }
            @formatter.config_updated(yaml_path)
          end
          unless @yaml["deployment"]["team_token"]
            @yaml["deployment"]["team_token"] = "example"
            File.open(yaml_path, 'w') {|f|
              f.write(@yaml.to_yaml)
            }
            @formatter.config_updated(yaml_path)
          end
        end
      end

      #
      # The bundle_directory option is the directory which applications are bundled too
      #
      # @return [String] The bundle_directory path defined in config.yml
      def bundle_directory
        @yaml["paths"]["bundle_directory"]
      end

      #
      # The deploy_url is the target url used when deploying
      #
      # @return [String] The deployment url defined in config.yml
      def deploy_url
        if !@yaml["deployment"]["url"]
          return ""
        end
        if @yaml["deployment"]["url"] != "http://example.com"
          @yaml["deployment"]["url"]
        end
      end

      #
      # The api token used for deployment
      #
      # @return [String] The api token defined in config.yml
      def api_token
        @yaml["deployment"]["api_token"] if @yaml["deployment"]["api_token"] and @yaml["deployment"]["api_token"] != "example"
      end

      #
      # The team token used for deployment
      #
      # @return [String] The team token defined in config.yml
      def team_token
        @yaml["deployment"]["team_token"] if @yaml["deployment"]["team_token"] and @yaml["deployment"]["teamt_oken"] != "example"
      end

      #
      # The mail account is the account used when sending SMTP mail
      #
      # @return [String] The mail account defined in config.yml
      def mail_account
        @yaml["mail"]["account"] if @yaml["mail"]["account"] and @yaml["mail"]["account"] != "example@example.com"
      end

      #
      # The mail password is the password used when sending SMTP mail
      #
      # @return [String] The mail password defined in config.yml
      def mail_password
        @yaml["mail"]["password"] if @yaml["mail"]["password"]  and @yaml["mail"]["password"]  != "example"
      end

      #
      # The mail port used when sending SMTP mail
      #
      # @return [Number] The mail port defined in config.yml
      def mail_port
        @yaml["mail"]["port"] if @yaml["mail"]["port"] and @yaml["mail"]["port"] != 0
      end

      #
      # The mail host used when sending SMTP mail
      #
      # @return [String] The mail host defined in config.yml
      def mail_host
        @yaml["mail"]["host"] if @yaml["mail"]["host"] and @yaml["mail"]["host"] != "your.server.ip"
      end

      #
      # The email address that SMTP mails are sent from
      #
      # @return [String] The from address defined in config.yml
      def mail_from
        @yaml["mail"]["from"] if @yaml["mail"]["from"] and @yaml["mail"]["from"] != "example@example.com"
      end

      #
      # The path to the users home directory, same as ~
      #
      # @return [String] The full path to the current users home directory
      def user_directory
        File.expand_path('~')
      end

      #
      # The path to the users config.yml
      #
      # @return [String] The full path to the users config.yml file in their home directory
      def yaml_path
        "#{user_directory}/.yolo/config.yml"
      end

      #
      # The path to the users .yolo directory, this is directory which contains config.yml
      #
      # @return [String] The full path to the users .yolo directory
      def yolo_dir
        "#{user_directory}/.yolo"
      end

      #
      # Creates the .yolo directory in the users home directory (~)
      #
      def create_yolo_dir
        unless File.directory?(yolo_dir)
          FileUtils.mkdir_p(yolo_dir)
        end
      end

    end
  end
end
