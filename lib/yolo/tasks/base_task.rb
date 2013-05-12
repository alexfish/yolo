require 'xcodebuild'
require 'rake/tasklib'

module Yolo
  module Tasks
    #
    # A base task class to subclass from when creating tasks
    #
    # @author [Alex Fish]
    #
    class BaseTask < XcodeBuild::Tasks::BuildTask

      #
      # The name to use for folders etc taken from the scheme or target name
      #
      # @return [String] a name
      def name
        self.scheme ? self.scheme : self.target
      end

      #
      # Defines available rake tasks
      #
      def define
      end
    end
  end
end
