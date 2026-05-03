module KindOfJeopardy
  class States
    class Connecting < KindOfJeopardy::State
      def setup
        super

        @client = KindOfJeopardy::Networking::Client.new(host: @options[:hostname], port: @options[:port], channels: 1)
        @client.use_compression(true)
        window.socket = @client

        background GAME_BACKGROUND

        stack(width: 1.0, height: 1.0) do
          @status = banner "Connecting...", width: 1.0, height: 1.0, text_align: :center, text_v_align: :center
        end
      end

      def update
        super

        if @client&.data?
          pop_state
          push_state(States::Game, context: @client.data)
        end
      end
    end
  end
end
