module KindOfJeopardy
  class States
    class SetupGame < KindOfJeopardy::State
      def setup
        super

        background 0xff_353535

        flow(width: 1.0, height: 1.0) do
          stack(width: 0.5, max_width: 480, height: 1.0, padding: PADDING) do
            banner "Setup Game", width: 1.0, text_align: :center

            button "Play", width: 1.0, margin_top: LARGE_PADDING, enabled: false do
              pop_state
              push_state(States::Game)
            end

            button "Main Menu", width: 1.0, margin_top: LARGE_PADDING do
              pop_state
              push_state(MainMenu)
            end
          end

          stack(fill: true, height: 1.0, scroll: true, padding: PADDING) do
            background GAME_BACKGROUND

            title "Categories", width: 1.0, text_align: :center
            flow(width: 1.0, height: 80) do
              6.times do
                button("NOT SET", width: 1.0 / 6.0, height: 1.0, style_class: [:jeopardy_button], text_size: 18) do
                end
              end
            end

            title "Teams", width: 1.0, text_align: :center, margin_top: LARGE_PADDING
            flow(width: 1.0, height: 80) do
              8.times do
                button("NOT SET", width: 1.0 / 8.0, height: 1.0, style_class: [:jeopardy_button], text_size: 18) do
                end
              end
            end

            title "Options", width: 1.0, text_align: :center, margin_top: LARGE_PADDING
            flow(width: 1.0) do
              stack(width: 0.33) do
                subtitle "Score Multiplier", width: 1.0, text_align: :center
                list_box items: ["1", "2", "3", "4", "5", "6"], width: 1.0
              end
              stack(width: 0.33) do
                subtitle "Answer Time (seconds)", width: 1.0, text_align: :center
                list_box items: ["5", "10", "15", "20", "25", "30", "unlimited"], choose: "10", width: 1.0
              end
              stack(width: 0.33) do
                subtitle "Categories Guessable?", width: 1.0, text_align: :center
                toggle_button width: 1.0
              end
            end

            flow(width: 1.0, margin_top: LARGE_PADDING) do
              stack(width: 0.33) do
                subtitle "Answer Score", width: 1.0, text_align: :center
                stack(width: 1.0) do
                  flow(width: 1.0, height: 60) do
                    tagline "Row 0", height: 1.0, text_v_align: :center, tip: "Category Row"
                    edit_line "200", fill: true
                  end
                  flow(width: 1.0, height: 60) do
                    tagline "Row 1", height: 1.0, text_v_align: :center
                    edit_line "200", fill: true
                  end
                  flow(width: 1.0, height: 60) do
                    tagline "Row 2", height: 1.0, text_v_align: :center
                    edit_line "400", fill: true
                  end
                  flow(width: 1.0, height: 60) do
                    tagline "Row 3", height: 1.0, text_v_align: :center
                    edit_line "600", fill: true
                  end
                  flow(width: 1.0, height: 60) do
                    tagline "Row 4", height: 1.0, text_v_align: :center
                    edit_line "800", fill: true
                  end
                  flow(width: 1.0, height: 60) do
                    tagline "Row 5", height: 1.0, text_v_align: :center
                    edit_line "1000", fill: true
                  end
                end
              end

              stack(width: 0.66, margin_left: LARGE_PADDING) do
                subtitle "Game Controller", width: 1.0, text_align: :center
                tagline "Displays", width: 1.0, text_align: :center
                list_box items: ["1", "2", "networked"], width: 1.0

                tagline "Interface", width: 1.0, text_align: :center
                list_box items: ["192.168.1.1"], width: 1.0
                tagline "Port", width: 1.0, text_align: :center
                edit_line "56789", width: 1.0
                tagline "Password", width: 1.0, text_align: :center
                edit_line "", width: 1.0, type: :password
              end
            end
          end
        end
      end
    end
  end
end
