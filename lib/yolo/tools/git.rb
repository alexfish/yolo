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
        self.project_name = name unless name.nil?
        commit = latest_commit
        if yaml_commit == commit
          @formatter.no_new_commit
          @commit = nil
          false
        else
          @formatter.new_commit(commit)
          update_commit(commit)
          @commit = commit
          true
        end
      end

      #
      # Checks against the yaml history to see if a new tag is present to build
      # @param  name [String] the project name, used as a unique id in the yaml history
      #
      # @return [BOOL] returns if there is a new tag to build
      def has_new_tag(name)
        self.project_name = name unless name.nil?
        tag = latest_tag
        if yaml_tag == tag
          @formatter.no_new_tag
          @tag = nil
          false
        else
          @formatter.new_tag(tag)
          update_tag(tag)
          @tag = tag
          true
        end
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
      # Updates the tag history
      # @param  new_tag [String] The new tag to store as the latest
      #
      def update_tag(new_tag)
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
        match = log.scan(/tag:\sv?[0-9]*\.[0-9]*[\.[0-9]*]*[[a-zA-Z]*]?/).first
        if match.nil?
          ""
        else
          match
        end
      end


      #
      # Uses git log and some regex to find the latest commit hash on the current branch, returns
      # empty if no tag is found
      #
      # @return [String] The commit hash
      def latest_commit
        match = log.scan(/\b[0-9a-f]{5,40}\b/).first
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
        `git log #{current_branch} --decorate=short -n 1 --pretty=oneline`
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
