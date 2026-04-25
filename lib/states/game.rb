module KindOfJeopardy
  class States
    class Game < KindOfJeopardy::State
      def setup
        super

        @data = JSON.parse(File.read("./data/sample.jsonc"), symbolize_names: true)

        flow(width: 1.0, height: 1.0, padding: HALF_PADDING, background: GAME_BACKGROUND) do
          6.times do
            cat = @data[:categories].first
            # @data[:categories].each do |cat|
              stack(fill: true, height: 1.0) do
                # category
                button(cat[:name].to_s.upcase, width: 1.0, fill: true, style_class: [:jeopardy_button, :jeopardy_header], margin_bottom: HALF_PADDING) do
                end

                # quiz item
                cat[:questions].each do |question|
                  button question[:label].to_s, width: 1.0, fill: true, style_class: [:jeopardy_button], enabled: rand > 0.5
                end
              end
            # end
          end
        end
      end

      def button_down(id)
        super

        case id
        when Gosu::KB_ESCAPE
          push_state(PauseMenu)
        end
      end
    end
  end
end
