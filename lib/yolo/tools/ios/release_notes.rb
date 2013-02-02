require 'Redcarpet'

module Yolo
  module Tools
    module Ios
      module ReleaseNotes
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

        def self.html
          notes = "#{Dir.pwd}/release_notes.md"
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
