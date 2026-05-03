module KindOfJeopardy
  class States
    class GameDirector < KindOfJeopardy::State
      def setup
        super

        @context = @options[:context] || States::Game::Context.new

        @server = KindOfJeopardy::Networking::Server.new(host: "0.0.0.0", port: 56789, max_clients: 32, channels: 1)
        @server.use_compression(true)
        window.socket = @server

        # broadcast game state every n seconds so game viewers can "connect"
        every(3_000) do
          @server.broadcast(@context.to_json)
        end

        background 0xff_353535

        stack(width: 1.0, height: 1.0) do
          # turns and game questions
          flow(width: 1.0, fill: true) do
            # turns
            stack(width: 512, height: 1.0) do
              banner "Turns", width: 1.0, text_align: :center
              # turn history
              stack(width: 1.0, fill: true, scroll: true, padding: PADDING) do
                36.times do |i|
                  flow(width: 1.0, padding: HALF_PADDING, margin_bottom: HALF_PADDING, background_nine_slice_color: 0x44_111111, background_nine_slice: NINE_SLICE_BACKGROUND) do
                    # turn id
                    caption format("%2d", i)
                    caption "00:10"
                    rand(8).times do |v|
                      # teams guessed
                      flow(width: 18, height: 18, margin_left: HALF_PADDING, v_align: :center, tip: "TEAM NAME", background_nine_slice_color: TEAM_COLORS.values.sample, background_nine_slice: NINE_SLICE_BACKGROUND) do
                      end
                    end
                    flow(fill: true)
                    # team successfully answered
                    flow(width: 18, height: 18, margin_left: HALF_PADDING, v_align: :center, tip: "TEAM NAME", background_nine_slice_color: TEAM_COLORS.values.sample, background_nine_slice: NINE_SLICE_BACKGROUND) do
                    end
                  end
                end
              end
            end

            # game questions
            stack(fill: true, height: 1.0) do
              background GAME_BACKGROUND

              flow(width: 1.0, fill: true) do
                @context.categories.each do |category|
                  next unless category

                  stack(fill: true, height: 1.0) do
                    button category.name, width: 1.0, fill: true, text_size: 24, style_class: [:jeopardy_header], margin_bottom: HALF_PADDING

                    category.questions.each_with_index do |question, i|
                      next unless i.positive?

                      button @context.options[:"answer_score_row_#{i}"] * @context.options[:score_multiplier], width: 1.0, fill: true, text_size: 24, style_class: [:jeopardy_button]
                    end
                  end
                end
              end
            end
          end

          # game director team selection and question result
          flow(width: 1.0, padding: PADDING, background: 0x44_00ff00) do

            # clock
            flow(width: 96 * 2, height: 96, margin_left: HALF_PADDING, padding: HALF_PADDING, v_align: :center, tip: "TEAM NAME", background_nine_slice_color: 0xaa_000000, background_nine_slice: NINE_SLICE_BACKGROUND) do
              title "00:00", width: 1.0, height: 1.0, text_align: :center, text_v_align: :center
            end

            flow(fill: true)

            # teams
            @context.teams.each do |team|
              next unless team

              # teams guessing
              button("99999", width: 96, height: 96, text_size: 24, margin_left: HALF_PADDING, padding: HALF_PADDING, v_align: :center, tip: team.name, background_nine_slice_color: TEAM_COLORS[team.color], background_nine_slice: NINE_SLICE_BACKGROUND, text_wrap: :word_wrap) do
              end
            end

            # state controller
            flow(fill: true, height: 96, padding: HALF_PADDING, v_align: :center) do
              flow(fill: true)

              button "REJECT", padding: PADDING, height: 1.0
              button "ACCEPT", padding: PADDING, height: 1.0
            end
          end
        end
      end
    end
  end
end
