require 'net/imap'
require 'net/pop'
require 'openssl'
require 'timeout'


module RedmineContacts
  module Mailer
    class << self

      def check_imap(mailer, imap_options={}, options={})
        host = imap_options[:host] || '127.0.0.1'
        port = imap_options[:port] || '143'
        ssl = !imap_options[:ssl].nil?
        folder = imap_options[:folder] || 'INBOX'

        Timeout::timeout(15) do
          @imap = Net::IMAP.new(host, port, ssl)        
          @imap.login(imap_options[:username], imap_options[:password]) unless imap_options[:username].nil?
        end
        
        @imap.select(folder)
        msg_count = 0

        @imap.search(['NOT', 'SEEN']).each do |message_id|
          msg = @imap.fetch(message_id,'RFC822')[0].attr['RFC822']
          logger.info "ContactsMailHandler: Receiving message #{message_id}" if logger && logger.info?
          msg_count += 1

          if mailer.receive(msg, options)
            logger.info "ContactsMailHandler: Message #{message_id} successfully received" if logger && logger.info?
            if imap_options[:move_on_success] && imap_options[:move_on_success] != folder
              @imap.copy(message_id, imap_options[:move_on_success])
            end
            @imap.store(message_id, "+FLAGS", [:Seen, :Deleted])
          else
            logger.info "ContactsMailHandler: Message #{message_id} can not be processed" if logger && logger.info?
            @imap.store(message_id, "+FLAGS", [:Seen])
            if imap_options[:move_on_failure]
              @imap.copy(message_id, imap_options[:move_on_failure])
              @imap.store(message_id, "+FLAGS", [:Deleted])
            end
          end
        end
        @imap.expunge
        msg_count
      ensure
        if defined?(@imap) && @imap && !@imap.disconnected?
          @imap.disconnect
        end
      end    
      
      def check_pop3(mailer, pop_options={}, options={})
        
        host = pop_options[:host] || '127.0.0.1'
        port = pop_options[:port] || '110'
        apop = (pop_options[:apop].to_s == '1')
        delete_unprocessed = (pop_options[:delete_unprocessed].to_s == '1')

        pop = Net::POP3.APOP(apop).new(host,port)
        pop.enable_ssl(OpenSSL::SSL::VERIFY_NONE) if pop_options[:ssl]
        logger.info "ContactsMailHandler: Connecting to #{host}..." if logger && logger.info?
        msg_count = 0
        pop.start(pop_options[:username], pop_options[:password]) do |pop_session|
          if pop_session.mails.empty?
            logger.info "ContactsMailHandler: No email to process" if logger && logger.info?
          else
            logger.info "ContactsMailHandler: #{pop_session.mails.size} email(s) to process..." if logger && logger.info?
            pop_session.each_mail do |msg|
              msg_count += 1
              message = msg.pop
              message_id = (message =~ /^Message-ID: (.*)/ ? $1 : '').strip
              if mailer.receive(message, options)
                msg.delete
                logger.info "--> ContactsMailHandler: Message #{message_id} processed and deleted from the server" if logger && logger.info?
              else
                if delete_unprocessed
                  msg.delete
                  logger.info "--> ContactsMailHandler: Message #{message_id} NOT processed and deleted from the server" if logger && logger.info?
                else
                  logger.info "--> ContactsMailHandler: Message #{message_id} NOT processed and left on the server" if logger && logger.info?
                end
              end
            end
          end
        end
        msg_count
      ensure
        if defined?(pop) && pop && pop.started?
          pop.finish
        end
      end

      private

      def logger
        ::Rails.logger
      end

    end
  end
end
