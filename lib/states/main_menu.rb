module Jeopardy
  class States
    class MainMenu < Jeopardy::State
      def setup
        super

        background 0xff_353535
        banner Jeopardy::NAME

        stack(fill: true, width: 0.5, max_width: 480) do
          button "Play", width: 1.0 do
            pop_state
            push_state(States::Game)
            # push_state(States::QuizSelectMenu)
          end

          button "Quiz Editor", width: 1.0, margin_top: 16 do
            pop_state
            push_state(States::QuizEditor)
          end

          button "Quit", width: 1.0, margin_top: 16 do
            window.close
          end
        end
      end
    end
  end
end
