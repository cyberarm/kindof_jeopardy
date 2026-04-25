module KindOfJeopardy
  class States
    class PauseMenu < KindOfJeopardy::Dialog
      def setup
        super

        background 0xee_353535

        stack(fill: true, width: 0.5, max_width: 480, h_align: :center, padding: PADDING) do
          banner "Game Paused", width: 1.0, text_align: :center

          button "Resume", width: 1.0, margin_top: LARGE_PADDING do
            pop_state
          end

          button "Quit to Main Menu", width: 1.0, margin_top: LARGE_PADDING do
            pop_state
            push_state(MainMenu)
          end

          button "Exit to Desktop", width: 1.0, margin_top: PADDING do
            window.close
          end
        end
      end
    end
  end
end
