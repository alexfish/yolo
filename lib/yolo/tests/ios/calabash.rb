require "calabash-cucumber"

module Yolo
  module Tests
    module Ios
      module Calabash
        def self.run(output = :junit, output_dir = "cucumber-test-reports")
          IO.popen("cucumber --format #{output.to_s} --out #{output_dir}") do |io|
            begin
              while line = io.readline
                begin
                  puts line # do something with this..
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
