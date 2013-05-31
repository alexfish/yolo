require 'yaml'

module Yolo
  module Tools
    #
    # Runs git commands
    #
    # @author [Alex Fish]
    #
    class Git

      # A unique name used to identify the project and its history
      attr_accessor :project_name

      #
      # Creates the class with default variables, sets the path to the history
      # yml file and loads it.
      #
      def initialize
        @yaml_path = File.dirname(__FILE__) + "/../history/history.yml"
        @yaml = YAML::load_file @yaml_path
        @formatter = Yolo::Formatters::ProgressFormatter.new
      end

      #
      # Checks against the yaml history to see if a new commit is present to build
      # @param  name [String] the project name, used as a unique id in the yaml history
      #
      # @return [BOOL] returns if there is a new commit to build
      def has_new_commit(name)
        set_project_name(name)
        if yaml_commit == latest_commit
          @formatter.no_new_commit
          false
        else
          @formatter.new_commit(latest_commit)
          update_commit(latest_commit)
          true
        end
      end

      #
      # Checks against the yaml history to see if a new tag is present to build
      # @param  name [String] the project name, used as a unique id in the yaml history
      #
      # @return [BOOL] returns if there is a new tag to build
      def has_new_tag(name)
        new_tag = false
        set_project_name(name)

        if latest_tag
          if yaml_tag != latest_tag or has_new_commit(name)
            @formatter.new_tag(latest_tag)
            update_tag(latest_tag)
            new_tag = true
          end
        end

        unless new_tag
          @formatter.no_new_tag
        end

        new_tag
      end

      #
      # The latest git tag
      #
      # @return [String] The latest git tag for the project
      def tag
        @tag
      end

      #
      # The latest commit hash
      #
      # @return [String] The latest git commit hash for the project
      def commit
        @commit
      end

      private

      #
      # Sets the current project name
      #
      def set_project_name(name)
        self.project_name = name unless name.nil?
      end

      #
      # Updates the tag history
      # @param  new_tag [String] The new tag to store as the latest
      #
      def update_tag(new_tag)
        @tag = new_tag
        if @yaml[project_name]
          @yaml[project_name]["tag"] = new_tag
        else
          @yaml[project_name] = {"tag" => new_tag, "commit" => ""}
        end
        save_yaml
      end

      #
      # Updates the commit history
      # @param  new_commit [String] The new commit hash to store as the latest
      #
      def update_commit(new_commit)
        @commit = new_commit
        if @yaml[project_name]
          @yaml[project_name]["commit"] = new_commit
         else
          @yaml[project_name] = {"tag" => "", "commit" => new_commit}
        end
        save_yaml
      end

      #
      # Writes the yaml hash to the history file saving the latest commit and tag
      #
      def save_yaml
        File.open(@yaml_path, 'w') {|f|
          f.write(@yaml.to_yaml)
        }
      end

      #
      # Uses git log and some regex to find the latest tag on the current branch, returns
      # empty if no tag is found
      #
      # @return [String] The tag
      def latest_tag
        match = ""
        matches = log.scan(/tag:\s(.+?),\s/)
        if matches.nil?
          ""
        else
          matches.each do |tag|
            if !tag.first.include? "jenkins"
              match = tag.first
              break
            end
          end
          return match
        end
      end


      #
      # Uses git log and some regex to find the latest commit hash on the current branch, returns
      # empty if no tag is found
      #
      # @return [String] The commit hash
      def latest_commit
        matches = log.scan(/\b[0-9a-f]{5,40}\b/)
        match = matches.first
        if match.nil?
          ""
        else
          match
        end
      end

      #
      # The last commit that was checked, loaded from the yaml file
      #
      # @return [String] The last commit hash from the project history
      def yaml_commit
        if @yaml[project_name]
          @yaml[project_name]["commit"]
        else
          ""
        end
      end

      #
      # The last tag that was checked, loaded from the yaml file
      #
      # @return [String] The last tag from the project history
      def yaml_tag
        if @yaml[project_name]
          @yaml[project_name]["tag"]
        else
          ""
        end
      end

      #
      # Executes a git log command on the current branch
      #
      # @return [String] git log's output
      def log
        `git log --decorate=short -n 1 --pretty=oneline`
      end

      #
      # Finds the current branch using some regex and git branch
      #
      # @return [String] The current branch name
      def current_branch
        branch = `git branch`
        branchs = branch.split("\n")
        current_branch = ""
        branchs.each do |b|
          current_branch = b if b.count("*") == 1
        end
        current_branch.gsub("* ", "")
      end
    end
  end
end
