module KindOfJeopardy
  class States
    class SetupGame < KindOfJeopardy::State
      def setup
        super

        @context = Game::Context.new(Array.new(MAX_TEAMS) { nil }, Array.new(MAX_CATEGORIES) { nil }, {}, [])

        background 0xff_353535

        flow(width: 1.0, height: 1.0) do
          stack(width: 0.5, max_width: 480, height: 1.0, padding: PADDING) do
            banner "Setup Game", width: 1.0, text_align: :center

            @play_button = button "Host", width: 1.0, margin_top: LARGE_PADDING, enabled: false do
              pop_state
              attach_options_to_context
              pp @context
              push_state(States::GameDirector, context: @context)
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
              ITEMS_PER_ROW.times do |i|
                button("", width: 1.0 / 6.0, height: 1.0, style_class: [:jeopardy_button], text_size: 18) do |btn|
                  dialog(CategorySelectionDialog, context: @context, category: @context.categories[i], callback: ->(category) {
                    if category
                      btn.value = category.name
                      @context.categories[i] = category
                    else
                      btn.value = ""
                      @context.categories[i] = nil
                    end

                    pp @context
                  })
                end
              end
            end

            title "Teams", width: 1.0, text_align: :center, margin_top: LARGE_PADDING
            flow(width: 1.0, height: 80) do
              8.times do |i|
                button("", width: 1.0 / 8.0, height: 1.0, text_wrap: :word_wrap, style_class: [:jeopardy_button], color: 0xff_ffffff, text_size: 18) do |btn|
                  dialog(TeamDialog, context: @context, team: @context.teams[i], callback: ->(team) {
                    if team
                      @_team_button_color ||= btn.style.background_nine_slice_color

                      btn.value = team.name
                      btn.style.background_nine_slice_color = TEAM_COLORS[team.color]
                      @context.teams[i] = team
                    else
                      btn.value = ""
                      @context.teams[i] = nil
                      btn.style.background_nine_slice_color = @_team_button_color if @_team_button_color
                    end
                  })
                end
              end
            end

            title "Options", width: 1.0, text_align: :center, margin_top: LARGE_PADDING
            flow(width: 1.0) do
              stack(width: 0.33) do
                subtitle "Score Multiplier", width: 1.0, text_align: :center, tip: "Multiplies Answer Score by this amount."
                @score_multiplier = list_box items: ["1", "2", "3", "4", "5", "6"], width: 1.0
              end
              stack(width: 0.33) do
                subtitle "Answer Time (seconds)", width: 1.0, text_align: :center, tip: "Time player has after being acknowledged to answer the question to the Host's satisfaction."
                @answer_time = list_box items: ["5", "10", "15", "20", "25", "30", "unlimited"], choose: "10", width: 1.0
              end
              stack(width: 0.33) do
                subtitle "Categories Guessable?", width: 1.0, text_align: :center, tip: "The category label will be hidden and players can attempt to guess the category for bonus points."
                @categories_guessable = toggle_button width: 1.0, enabled: false
              end
              stack(width: 0.33) do
                subtitle "Auto Acknowledge?", width: 1.0, text_align: :center, tip: "Whether the first player to push the button will immediately be able to try to answer it."
                @auto_acknowledge = toggle_button width: 1.0, enabled: false
              end
            end

            flow(width: 1.0, margin_top: LARGE_PADDING) do
              stack(width: 0.33) do
                subtitle "Answer Score", width: 1.0, text_align: :center
                stack(width: 1.0) do
                  flow(width: 1.0, height: 60) do
                    tagline "Row 0", height: 1.0, text_v_align: :center, tip: "Category Row"
                    @answer_score_row_0 = edit_line "200", fill: true, filter: method(:answer_score_filter)
                  end
                  flow(width: 1.0, height: 60) do
                    tagline "Row 1", height: 1.0, text_v_align: :center
                    @answer_score_row_1 = edit_line "200", fill: true, filter: method(:answer_score_filter)
                  end
                  flow(width: 1.0, height: 60) do
                    tagline "Row 2", height: 1.0, text_v_align: :center
                    @answer_score_row_2 = edit_line "400", fill: true, filter: method(:answer_score_filter)
                  end
                  flow(width: 1.0, height: 60) do
                    tagline "Row 3", height: 1.0, text_v_align: :center
                    @answer_score_row_3 = edit_line "600", fill: true, filter: method(:answer_score_filter)
                  end
                  flow(width: 1.0, height: 60) do
                    tagline "Row 4", height: 1.0, text_v_align: :center
                    @answer_score_row_4 = edit_line "800", fill: true, filter: method(:answer_score_filter)
                  end
                  flow(width: 1.0, height: 60) do
                    tagline "Row 5", height: 1.0, text_v_align: :center
                    @answer_score_row_5 = edit_line "1000", fill: true, filter: method(:answer_score_filter)
                  end
                end
              end

              stack(width: 0.66, margin_left: LARGE_PADDING) do
                subtitle "Game Controller", width: 1.0, text_align: :center
                tagline "Displays", width: 1.0, text_align: :center
                @game_controller_displays = list_box items: ["1", "2+", "networked"], choose: "networked", enabled: false, width: 1.0 do |value|
                  case value
                  when "networked"
                    @game_controller_network_interface.enabled = true
                    @game_controller_network_port.enabled = true
                    @game_controller_password.enabled = true
                  else
                    @game_controller_network_interface.enabled = false
                    @game_controller_network_port.enabled = false
                    @game_controller_password.enabled = false
                  end
                end

                tagline "Network Interface", width: 1.0, text_align: :center
                @game_controller_network_interface = list_box items: Socket.ip_address_list.select(&:ipv4_private?).map(&:ip_address), width: 1.0

                tagline "Network Port", width: 1.0, text_align: :center
                @game_controller_network_port = edit_line DEFAULT_NETWORK_PORT, width: 1.0

                tagline "Password", width: 1.0, text_align: :center
                @game_controller_password = edit_line "", width: 1.0, type: :password
              end
            end
          end
        end
      end

      def update
        super

        @play_button.enabled = game_ready?
      end

      def attach_options_to_context
        @context.options[:score_multiplier] = @score_multiplier.value&.to_i || 1
        @context.options[:answer_time_seconds] = @answer_time.value == "unlimited" ? Float::INFINITY : @answer_time.value.to_i
        @context.options[:categories_guessable] = @categories_guessable.value
        @context.options[:auto_acknowledge] = @auto_acknowledge.value

        @context.options[:answer_score_row_0] = @answer_score_row_0.value.to_i
        @context.options[:answer_score_row_1] = @answer_score_row_1.value.to_i
        @context.options[:answer_score_row_2] = @answer_score_row_2.value.to_i
        @context.options[:answer_score_row_3] = @answer_score_row_3.value.to_i
        @context.options[:answer_score_row_4] = @answer_score_row_4.value.to_i
        @context.options[:answer_score_row_5] = @answer_score_row_5.value.to_i

        @context.options[:game_controller_displays] = @game_controller_displays.value
        @context.options[:game_controller_network_interface] = @game_controller_network_interface.value
        @context.options[:game_controller_network_port] = @game_controller_network_port.value.to_i
        @context.options[:game_controller_password] = @game_controller_password.value
      end

      def game_ready?
        @context.teams.any? { |t| t != nil } &&
        @context.categories.any? { |c| c != nil } &&
        @answer_score_row_0.value.to_i > 0 &&
        @answer_score_row_1.value.to_i > 0 &&
        @answer_score_row_2.value.to_i > 0 &&
        @answer_score_row_3.value.to_i > 0 &&
        @answer_score_row_4.value.to_i > 0 &&
        @answer_score_row_5.value.to_i > 0
      end

      def answer_score_filter(input)
        return "" if window.text_input.text.length >= 4
        return "" unless ("0".."9").include?(input)

        input
      end
    end
  end
end
