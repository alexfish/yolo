require 'net/smtp'

module Yolo
  module Notify
    module Ios
      class OTAEmail < Yolo::Notify::Email

        def body(opts)
          file = File.open(§ + "/email.html", "r")
          file.read
        end

      end
    end
  end
end
