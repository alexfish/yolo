require 'net/smtp'

module Yolo
  module Notify
    module Ios
      class OTAEmail < Yolo::Notify::Email

        def body(opts)
          file = File.open(File.dirname(__FILE__) + "/email.html", "r")
          content = file.read

          message = <<MESSAGE_END
To: A Test User <test@todomain.com>
MIME-Version: 1.0
Content-type: text/html
Subject: #{opts[:subject]}

#{content}
MESSAGE_END
        end
      end
    end
  end
end
