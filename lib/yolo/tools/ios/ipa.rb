require 'CFPropertyList'

module Yolo
  module Tools
    module Ios
      class IPA
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
