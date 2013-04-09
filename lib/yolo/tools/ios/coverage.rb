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
                begin
                  STDOUT << line
                rescue StandardError => e
                  puts "Error from output buffer: #{e.inspect}"
                  puts e.backtrace
                end
              end
            rescue EOFError
            end
          end
          $?.exitstatus
        end
      end
    end
  end
end
