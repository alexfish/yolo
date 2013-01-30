require 'net/smtp'

module Yolo
  module Notify
    module Ios
      class Email

        attr_accessor :to
        attr_accessor :from
        attr_accessor :server

        def initialize
          self.server = Yolo::Config::Settings.instance.mail_host
          self.from = Yolo::Config::Settings.instance.mail_from
          self.to = Yolo::Config::Settings.instance.mail_to
          @error_formatter = Yolo::Formatters::ErrorFormatter.new
        end

        def send(to,opts={})

          opts[:server]      ||= self.server
          opts[:from]        ||= self.from
          opts[:from_alias]  ||= 'Build Tools'
          opts[:subject]     ||= "New Notification"
          opts[:body]        ||= body(opts[:url],opts[:password])
          to                 ||= self.to

          if opts[:server].nil?
            @error_formatter.no_email_server
            return
          end

          if to.nil?
            @error_formatter.no_email_to
            return
          end
          msg = <<END_OF_MESSAGE
From: #{opts[:from_alias]} <#{opts[:from]}>
To: <#{to}>
Subject: #{opts[:subject]}

#{opts[:body]}
END_OF_MESSAGE

          Net::SMTP.start(opts[:server]) do |smtp|
            smtp.send_message msg, opts[:from], to
          end

          # do the send
        end

        def body(url,password)
          "URL:\n #{url}\n\nPassword:\n#{password}\n"
        end

      end
    end
  end
end
