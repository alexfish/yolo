require "calabash-cucumber"

module Yolo
  module Tools
    module Ios
      #
      # Runs calabash tests and outputs reports
      #
      # @author [Alex Fish]
      #
      module Calabash
        #
        # Runs cucumber calabash tests and outputs reports to a defined location
        # @param  format = :junit [Symbol] The test output type, defaults to junit for Jenkins, see the cucumber docs for more options
        # @param  output_dir = "test-reports/cucumber" [String] Folder destination to output the test reports to
        #
        # @return [type] [description]
        def self.run(format = :junit, output_dir = "test-reports/cucumber")
          IO.popen("cucumber --format #{format.to_s} --out #{output_dir}") do |io|
            begin
              while line = io.readline
                begin
                  puts line
                rescue StandardError => e
                  puts "Error from output buffer: #{e.inspect}"
                  puts e.backtrace
                end
              end
            rescue EOFError
            end
          end
          $?.exitstatus if $?
        end
      end
    end
  end
end
