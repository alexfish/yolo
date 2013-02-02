require 'Redcarpet'

module Yolo
  module Tools
    module Ios
      #
      # Generates and parses release notes for application releases
      #
      # @author [Alex Fish]
      #
      module ReleaseNotes
        #
        # Generates a release notes markdown file in the current directory
        # @param  plist_path [String] The full path to the applications info.plist
        #
        def self.generate(plist_path)
          xcode = Yolo::Tools::Ios::Xcode.new
          xcode.info_plist_path = plist_path
          directory = Dir.pwd
          time = Time.new

          File.open("#{directory}/release_notes.md", 'w') {|f|
            f.write("### Version\n- - -\n")
            f.write("#{xcode.version_number} (#{xcode.build_number})\n\n")
            f.write("### Change log\n- - -\n")
            f.write("* No Changes\n\n")
            f.write("### Fixes\n- - -\n")
            f.write("* No Fixes\n\n")
            f.write("### Notes\n- - -\n")
            f.write("No Notes\n\n")
            f.write("### Known issues\n- - -\n")
            f.write("No Known issues\n\n")
            f.write("### Date\n- - -\n")
            f.write("#{time.day}/#{time.month}/#{time.year} - #{time.hour}:#{time.min}")
          }

          formatter = Yolo::Formatters::ProgressFormatter.new
          formatter.notes_generated("#{directory}/release_notes.md")

          `open #{directory}/release_notes.md`
        end

        #
        # Uses Redcarpet to parse the release notes markdown file into html.
        #
        # @return [String] An html string representation of the current release_notes.md file
        def self.html
          notes = "#{Dir.pwd}/release_notes.md"
          unless File.exists(notes)
            error_formatter = Yolo::Formatters::ErrorFormatter.new
            error_formatter.no_notes(notes)
            return ""
          end

          file = File.open(notes, "r")
          file_content = file.read
          markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
          :autolink => true, :space_after_headers => true)
          content = markdown.render(file_content)
          content.gsub("\n","")
          content
        end
      end
    end
  end
end
