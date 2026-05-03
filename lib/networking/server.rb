module KindOfJeopardy
  module Networking
    LOCALHOST_MTU = 65_536
    NETWORK_MTU = 1_500

    class Server < ENet::Server
      def initialize(host:, port:, max_clients: 32, channels: 1)
        @host = host
        @port = port
        @max_clients = max_clients
        @channels = channels

        @socket = UDPSocket.new
        @socket.setsockopt(Socket::SOL_SOCKET, Socket::SO_REUSEADDR, true)
        @socket.setsockopt(Socket::SOL_SOCKET, Socket::SO_BROADCAST, true)
        @socket.bind(host, port)

        @clients = []
      end

      def update(delay)
      end

      def broadcast(data)
        @socket.send(data, 0, @host, @port)
      end

      def use_compression(bool)
      end

      def on_connection(client)
        pp [:connected]
      end

      def on_packet_received(client, data, channel)
        pp [client, data, channel]
      end

      def on_disconnection(client)
        pp [:disconnected]
      end
    end
  end
end
