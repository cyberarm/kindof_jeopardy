module KindOfJeopardy
  class States
    class TeamDialog < KindOfJeopardy::Dialog
      def setup
        super

        @context = @options[:context]
        @team = @options[:team]

        background 0xee_353535

        stack(fill: true, width: 0.5, max_width: 480, h_align: :center, padding: PADDING) do
          banner "Define Team", width: 1.0, text_align: :center

          stack(width: 1.0, fill: true, scroll: true) do
            title "Team Name"
            flow(width: 1.0) do
              @team_name = edit_line @team&.name || random_team_name, fill: true
              @team_name.subscribe(:changed) do
                if @context.teams.select { |t| !t.nil? && t != @team }.any? { |t| t.name.downcase.strip == @team_name.value.downcase.strip }
                  @accept_button.enabled = false
                  # FIXME:
                  @team_name.style.background_nine_slice_color = TEAM_COLORS["red"]
                  @team_name.stylize
                else
                  @accept_button.enabled = true
                end
              end
              # FIXME: Show refresh icon and add tooltip
              button(get_image("#{ROOT_PATH}/media/kenney/board-game-icons/card_rotate.png"), image_height: 32) do
                @team_name.value = random_team_name
              end
            end

            title "Team Color", margin_top: PADDING
            color_name = @team&.color || random_team_color
            colors = available_colors
            @team_color = button color_name, background_nine_slice_color: colors[color_name], width: 1.0 do |btn|
              menu(parent: btn, width: 1.0) do
                colors.each do |name, color|
                  menu_item(name, background_nine_slice_color: color) do
                    btn.value = name
                    btn.style.background_nine_slice_color = color
                  end
                end
              end.show
            end

            @accept_button = button "Accept", width: 1.0, margin_top: LARGE_PADDING do
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
          Faker::Space.star,
          Faker::Creature::Animal.name.capitalize,
          Faker::Movies::StarWars.droid,
          Faker::Superhero.name
        ].sample
      end

      def available_colors
        h = {}

        TEAM_COLORS.each do |key, value|
          # select colors that other teams aren't using,
          # exclude current team so we can correctly display and 'select' chosen color
          next if @context.teams.select { |t| !t.nil? }.any? { |t| t.color == key && t != @team }

          h[key] = value
        end

        h
      end

      def random_team_color
        available_colors.keys.sample
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
