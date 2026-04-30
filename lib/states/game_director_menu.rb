module KindOfJeopardy
  class States
    class GameDirectorMenu < KindOfJeopardy::State
      def setup
        super

        background 0xff_353535

        stack(fill: true, width: 0.5, max_width: 480, h_align: :center, padding: PADDING) do
          banner "Game Director Menu", width: 1.0, text_align: :center

          subtitle "Hostname", margin_top: LARGE_PADDING, width: 1.0, text_align: :center
          edit_line "", width: 1.0 do
          end
          subtitle "Port", width: 1.0, text_align: :center
          edit_line DEFAULT_NETWORK_PORT, width: 1.0 do
          end
          button "Connect", width: 1.0, margin_top: PADDING do
            pop_state
            push_state(States::SetupGame)
          end

          button "Back", width: 1.0, margin_top: LARGE_PADDING do
            pop_state
            push_state(States::MainMenu)
          end
        end
      end
    end
  end
end
