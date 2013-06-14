require 'tor-control/version'
require 'socket'
require 'logger'

module TorControl
  @host = 'localhost'
  @control_port = 9051
  @connection = false
  @password = false
  @logger = false
  class << self
    attr_accessor :connection, :host, :control_port, :password

    def configure(options={})
      if options[:host]
        @host = options[:host].to_s
      end
      if options[:control_port]
        @port = options[:control_port].to_i
      end
    end

    def new_identity
      connect
      authenticate
      signal_new_identity
      close
    end

    def logger
      return @logger if @logger
      @logger = Logger.new(STDERR)
    end

    def connect
      return @connection if @connection
      begin
      @connection = TCPSocket.new(@host, @control_port)
      rescue
        logger.error "TorControl: Failed to connection to tor service"
      end
    end

    def signal_new_identity
      check_connection
      send_line "SIGNAL NEWNYM"
      check_response { logger.error "TorControl: Error getting new indentity" }
    end

    def authenticate
      check_connection
      if @password
        send_line "AUTHENTICATE \"#{@password}\""
      else
        send_line "AUTHENTICATE"
      end
      check_response { logger.error "Tor Control: Authentication Failure!" }
    end

    def close
      check_connection
      send_line "QUIT"
      @connection = false
      return ! @connection
    end

    private

    def send_line command
      check_connection
      @connection.write command.to_s + "\r\n"
      @connection.flush
    end

    def read_line
      check_connection
      @connection.readline.chomp
    end

    def check_connection
      raise "Not connected" unless @connection
      true
    end

    def check_response(&block)
      unless read_line == "250 OK"
        block.call
      end
      true
    end

  end
end
