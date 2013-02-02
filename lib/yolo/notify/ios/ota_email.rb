require 'net/smtp'

module Yolo
  module Notify
    module Ios
      class OTAEmail < Yolo::Notify::Email

        def body(opts)
          message = <<MESSAGE_END
To: A Test User <test@todomain.com>
MIME-Version: 1.0
Content-type: text/html
Subject: #{opts[:subject]}

#{parsed_body(opts)}
MESSAGE_END
        end

        def parsed_body(opts)
          file = File.open(File.dirname(__FILE__) + "/email.html", "r")
          content = file.read
          markdown = Yolo::Tools::Ios::ReleaseNotes.html

          content = content.gsub("YOLO.TITLE",opts[:title])
          content = content.gsub("YOLO.CONTENT",markdown)
          content = content.gsub("YOLO.PASSWORD","<h3>Password</h3><hr><p>#{opts[:ota_password]}</p>")
          content = content.gsub("YOLO.Link",opts[:ota_url])
          content
        end

      end
    end
  end
end
