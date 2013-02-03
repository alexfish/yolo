require 'net/smtp'

module Yolo
  module Notify
    #
    # Sends emails via SMTP
    #
    # @author [Alex Fish]
    #
    class Email

      # An array of email addresses used in the to field
      attr_accessor :to
      # The email address used in the from feild
      attr_accessor :from
      # An SMTP server
      attr_accessor :server
      # The port to use when sending mail
      attr_accessor :port
      # The email account to use when sending mail
      attr_accessor :account
      # The account password to use when sending mail
      attr_accessor :password

      #
      # Initilizes an instance of the class with default settings
      # Loads defaults from Yolo::Config::Settings
      #
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

      #
      # Sends a nofification email using SMTP
      # @param  opts [Hash] An options hash, options are: server, from, subject, title, body, password, account, port, to
      #
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

      #
      # The body of them notification email, this method should be overwritten in subclasses
      # to provide custom content
      # @param  opts [Hash] A populated options hash, allows the use of options when generating email content
      #
      def body(opts)
        ""
      end

    end
  end
end
