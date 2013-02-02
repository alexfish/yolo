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
        # @param  &block [Block] Block called on completion
        #
        def self.generate(app_path,dsym_path,output_directory, &block)
          formatter = Yolo::Formatters::ProgressFormatter.new
          formatter.generating_ipa
          ipa_name = app_path.split("/").last.split(".").first

          unless File.directory?(output_directory)
            FileUtils.mkdir_p(output_directory)
          end

          # make ipa
          `/usr/bin/xcrun -sdk iphoneos PackageApplication -v #{app_path} -o #{output_directory}/#{ipa_name}.ipa`
          # move dsym
          FileUtils.cp_r(dsym_path, output_directory) if dsym_path
          # move release notes
          release_path = "#{Dir.pwd}/release_notes.md"
          FileUtils.cp_r(release_path, output_directory) if File.exist?(release_path)

          formatter.ipa_generated("#{output_directory}/#{ipa_name}.ipa")

          block.call("#{output_directory}/#{ipa_name}.ipa") if block
        end
      end
    end
  end
end
