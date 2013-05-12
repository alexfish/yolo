module Yolo
  module Tools
    module Ios
      #
      # Generates iOS IPA packages using xcrun
      #
      # @author [Alex Fish]
      #
      class IPA
        #
        # Generates an ipa package
        # @param  app_path [String] The full path to the .app file
        # @param  dsym_path [String] The full path to the dSYM folder
        # @param  output_directory [String] The full path to the ipa save destination
        # @param  block [Block] Block called on completion
        #
        def self.generate(app_path,dsym_path,output_directory, &block)
          formatter = Yolo::Formatters::ProgressFormatter.new
          formatter.generating_ipa
          name = self.app_name(app_path)
          # create directory
          self.create_directory(output_directory)
          # make ipa
          `/usr/bin/xcrun -sdk iphoneos PackageApplication -v #{app_path} -o #{output_directory}/#{name}.ipa`
          # move files
          self.move_file(dsym_path,output_directory)
          self.move_release_notes(output_directory)

          formatter.ipa_generated("#{output_directory}/#{name}.ipa")

          block.call("#{output_directory}/#{name}.ipa") if block
        end

        private

        #
        # Calculates the application name form the .app path
        #
        # @param  app_path [String] The full path to the .app file
        # @return [String] The name of the app
        def self.app_name(app_path)
          app_path.split("/").last.split(".").first
        end

        #
        # Creates a directory if missing
        # @param  directory [String] The path to the directory to create
        #
        def self.create_directory(directory)
          unless File.directory?(directory)
            FileUtils.mkdir_p(directory)
          end
        end

        #
        # Moves a file to a location
        # @param  file [String] The path to the file to move
        # @param  directory [String] The path to the directory to move the file to
        #
        def self.move_file(file, directory)
          # move dsym
          FileUtils.cp_r(file, directory) if file
        end

        #
        # Moves the projects releas notes file to a location
        # @param  directory [String] The directory to move the release notes to
        #
        # @return [type] [description]
        def self.move_release_notes(directory)
          # move release notes
          release_path = "#{Dir.pwd}/release_notes.md"
          if File.exist?(directory) and File.exist?(release_path)
            FileUtils.cp_r(release_path, directory)
          end
        end

      end
    end
  end
end
