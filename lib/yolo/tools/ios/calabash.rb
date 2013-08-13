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
        def self.run(format = :junit, output_dir = "test-reports/cucumber", device = "iphone")
          IO.popen("cucumber --format #{format.to_s} --out #{output_dir} DEVICE=#{device}") do |io|
            begin
              while line = io.readline
                puts line
              end
            rescue EOFError
              Yolo::Formatters::ProgressFormatter.new.tests_generated(output_dir)
            end
          end
          $?.exitstatus if $?
        end
      end
    end
  end
end
