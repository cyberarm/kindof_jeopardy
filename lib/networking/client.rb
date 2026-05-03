module KindOfJeopardy
  module Networking
    class Client# < ENet::Connection
      attr_reader :data

      def initialize(host:, port:, channels: 1)
        @host = host
        @port = port
        @channels = channels

        @socket = UDPSocket.new
        @socket.setsockopt(Socket::SOL_SOCKET, Socket::SO_REUSEADDR, true)
        @socket.setsockopt(Socket::SOL_SOCKET, Socket::SO_BROADCAST, true)
        @socket.bind(host, port)

        @data = nil
      end

      def update(delay)
        @data = States::Game::Context.from_json(
          JSON.parse(@socket.read_nonblock(LOCALHOST_MTU), symbolize_names: true)
        )
        @connected = true
      rescue IO::EAGAINWaitReadable
      rescue Errno::ECONNREFUSED
        @connected = false
      end

      def connected? = @connected

      def data? = @connected

      def use_compression(bool)
      end

      def on_connection
        pp [:connected]
      end

      def on_packet_received(data, channel)
        pp [data, channel]
      end

      def on_disconnection
        pp [:disconnected]
      end
    end
  end
end
