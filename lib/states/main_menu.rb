module KindOfJeopardy
  class States
    class MainMenu < KindOfJeopardy::State
      def setup
        super

        background 0xff_353535

        stack(fill: true, width: 0.5, max_width: 480, h_align: :center, padding: PADDING) do
          banner KindOfJeopardy::NAME, width: 1.0, text_align: :center

          button "Setup Game", width: 1.0, margin_top: LARGE_PADDING do
            pop_state
            push_state(States::SetupGame)
          end

          button "Category Editor", width: 1.0, margin_top: PADDING do
            pop_state
            push_state(States::CategoryEditorMenu)
          end

          button "Exit to Desktop", width: 1.0, margin_top: LARGE_PADDING do
            window.close
          end
        end
      end
    end
  end
end
