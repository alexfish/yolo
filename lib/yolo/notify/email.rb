require 'net/smtp'

module Yolo
  module Notify
    class Email

      attr_accessor :to
      attr_accessor :from
      attr_accessor :server
      attr_accessor :port
      attr_accessor :account
      attr_accessor :password

      def initialize
        self.server = Yolo::Config::Settings.instance.mail_host
        self.from = Yolo::Config::Settings.instance.mail_from
        self.to = Yolo::Config::Settings.instance.mail_to
        self.port = Yolo::Config::Settings.instance.mail_port
        self.account = Yolo::Config::Settings.instance.mail_account
        self.password = Yolo::Config::Settings.instance.mail_password

        @error_formatter = Yolo::Formatters::ErrorFormatter.new
        @progress_formatter = Yolo::Formatters::ProgressFormatter.new
      end

      def send(opts={})

        opts[:server]      ||= self.server
        opts[:from]        ||= self.from
        opts[:subject]     ||= "New Build!"
        opts[:title]       ||= "New Build!"
        opts[:body]        ||= body(opts)
        opts[:password]    ||= self.password
        opts[:account]     ||= self.account
        opts[:port]        ||= self.port
        opts[:to]          ||= self.to

        msg = opts[:body]

        if opts[:account] and opts[:password] and opts[:port] and opts[:to]
          @progress_formatter.sending_email
          smtp = Net::SMTP.new opts[:server], opts[:port]
          smtp.enable_starttls
          smtp.start(opts[:server], opts[:account], opts[:password], :login) do
            smtp.send_message(msg, opts[:from], opts[:to])
            @progress_formatter.email_sent(opts[:to])
          end
        elsif opts[:server] and opts[:to]
          @progress_formatter.sending_email
          Net::SMTP.start(opts[:server]) do |smtp|
            smtp.send_message(msg, opts[:from], opts[:to])
            @progress_formatter.email_sent(opts[:to])
          end
        else
          @error_formatter.missing_email_details
        end
      end

      def body(opts)
        ""
      end

    end
  end
end
