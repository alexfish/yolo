require 'yaml'

module Yolo
  module Tools
    class Git

      attr_accessor :project_name

      def initialize
        @yaml_path = File.dirname(__FILE__) + "/../history/history.yml"
        @yaml = YAML::load_file @yaml_path
        @formatter = Yolo::Formatters::ProgressFormatter.new
      end

      def is_new_commit(name)
        self.project_name = name unless name.nil?
        commit = latest_commit
        if yaml_commit == commit
          false
        else
          @formatter.new_commit(commit)
          update_commit(commit)
          true
        end
      end

      def is_new_tag(name)
        self.project_name = name unless name.nil?
        tag = latest_tag
        if yaml_tag == tag
          false
        else
          @formatter.new_tag(tag)
          update_tag(tag)
          true
        end
      end

      private

      def update_tag(new_tag)
        if @yaml[project_name]
          @yaml[project_name]["tag"] = new_tag
        else
          @yaml[project_name] = {"tag" => new_tag, "commit" => ""}
        end
        save_yaml
      end

      def update_commit(new_commit)
        if @yaml[project_name]
          @yaml[project_name]["commit"] = new_commit
         else
          @yaml[project_name] = {"tag" => "", "commit" => new_commit}
        end
        save_yaml
      end

      def save_yaml
        File.open(@yaml_path, 'w') {|f|
          f.write(@yaml.to_yaml)
        }
      end

      def latest_tag
        match = log.scan(/tag:\sv?[0-9]*\.[0-9]*[\.[0-9]*]*[[a-zA-Z]*]?/).first
        if match.nil?
          ""
        else
          match
        end
      end

      def latest_commit
        match = log.scan(/\b[0-9a-f]{5,40}\b/).first
        if match.nil?
          ""
        else
          match
        end
      end

      def yaml_commit
        if @yaml[project_name]
          @yaml[project_name]["commit"]
        else
          ""
        end
      end

      def yaml_tag
        if @yaml[project_name]
          @yaml[project_name]["tag"]
        else
          ""
        end
      end

      def log
        `git log #{current_branch} --decorate=short -n 1 --pretty=oneline`
      end

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
