require 'net/smtp'

module Yolo
  module Notify
    module Ios
      class OTAEmail < Yolo::Notify::Email

        def body(opts)
          "Subject: #{opts[:subject]}\n\nURL:\n#{opts[:ota_url]}\n\nPassword:\n#{opts[:ota_password]}\n"
        end

      end
    end
  end
end
