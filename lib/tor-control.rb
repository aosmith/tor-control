require "tor-control/version"
require "tor-control/tor_config"

module TorControl
  @host = '127.0.0.1'
  @control_port = 9051
  @connection = false
  @password = false
  @logger = false
  class << self
    attr_accessor :connection, :host, :port, :password

    def configure(options={})
      if options[:host]
        @host = options[:host].to_s
      end
      if options[:port]
        @port = options[:port].to_i
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
      begin
        @connection = TCPSocket.new(@host, @port)
      rescue
        logger.error "Failed to connection to tor service"
      end
    end

    def signal_new_identity
      check_connection
      send_line "SIGNAL NEWNYM"
      check_response { logger.error "Error getting new indentity" }
    end

    def authenticate
      check_connection
      if @password
        send_line "AUTHENTICATE \"#{@password}\""
      else
        send_line "AUTHENTICATE"
      end
      check_response { logger.error "Authentication Failure!" }
    end

    def close
      check_connection
      send_line "QUIT"
      @connection.close
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


end
