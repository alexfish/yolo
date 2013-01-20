require "calabash-cucumber"

module Yolo
  module Tools
    module Ios
      module Calabash
        def self.run(format = :junit, output_dir = "test-reports/cucumber")
          IO.popen("cucumber --format #{format.to_s} --out #{output_dir}") do |io|
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
