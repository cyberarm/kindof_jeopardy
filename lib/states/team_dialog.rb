module KindOfJeopardy
  class States
    class TeamDialog < KindOfJeopardy::Dialog
      def setup
        super

        @team = @options[:team]

        background 0xee_353535

        stack(fill: true, width: 0.5, max_width: 480, h_align: :center, padding: PADDING) do
          banner "Define Team", width: 1.0, text_align: :center

          stack(width: 1.0, fill: true, scroll: true) do
            title "Team Name"
            @team_name = edit_line @team&.name || random_team_name, width: 1.0

            title "Team Color", margin_top: PADDING
            color_name = @team&.color || random_team_color
            @team_color = button color_name, background_nine_slice_color: TEAM_COLORS[color_name], width: 1.0 do |btn|
              menu(parent: btn) do
                TEAM_COLORS.each do |name, color|
                  menu_item(name, background_nine_slice_color: color) do
                    btn.value = name
                    btn.style.background_nine_slice_color = color
                  end
                end
              end.show
            end

            button "Accept", width: 1.0, margin_top: LARGE_PADDING do
              pop_state
              @options[:callback]&.call(Game::Team.new(@team_name.value, @team_color.value))
            end
          end

          flow(width: 1.0, margin_top: LARGE_PADDING) do
            button "Cancel", fill: true do
              pop_state
            end
            button "Reset", fill: true do
              pop_state
              @options[:callback]&.call(nil)
            end
          end
        end
      end

      def random_team_name
        [
          Faker::Movies::StarWars.droid,
          Faker::Movies::StarWars.call_sign,
          Faker::Movies::StarWars.vehicle,
          Faker::Movies::Hobbit.character,
          Faker::Movies::Hobbit.location,
          Faker::Movies::LordOfTheRings.character,
          Faker::Movies::LordOfTheRings.location,
          Faker::Superhero.name
        ].sample
      end

      def random_team_color
        TEAM_COLORS.keys.sample
      end

      def button_down(id)
        super

        case id
        when Gosu::KB_ESCAPE
          pop_state
        end
      end
    end
  end
end
