module Yolo
  module Tools
    module Ios
      #
      # Runs test coverage calcuations using gcovr and outputs reports
      #
      # @author [Alex Fish]
      #
      module Coverage
        #
        # Runs gcovr and outputs reports to a defined location
        # @param  build_path = "" [String] The path to the build directory containing the .gcno compiler files
        # @param  output_dir = "" [String] Folder destination to output the report file too
        #
        # @return [type] [description]
        def self.calculate(build_path = "", output_dir = "")
          error_formatter = Yolo::Formatters::ErrorFormatter.new
          if build_path.length == 0 or output_dir.length == 0
            error_formatter.coverage_directory_error
            return
          end

          IO.popen("cd #{build_path} && gcovr --xml > #{output_dir}/coverage.xml") do |io|
            begin
              while line = io.readline
                puts line
              end
            rescue EOFError
              puts "Error while executing"
            end
          end
          $?.exitstatus if $?
        end
      end
    end
  end
end
