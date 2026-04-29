module KindOfJeopardy
  class States
    class CategorySelectionDialog < KindOfJeopardy::Dialog
      def setup
        super

        background 0xee_353535

        stack(fill: true, width: 0.5, max_width: 480, h_align: :center, padding: PADDING) do
          banner "Choose Category", width: 1.0, text_align: :center

          stack(width: 1.0, fill: true, scroll: true) do
            CATEGORIES.each do |category|
              widget(width: 1.0, margin_top: PADDING, **THEME[:Button], **THEME[:jeopardy_button]) do
                stack(width: 1.0) do
                  subtitle category.name, width: 1.0, text_align: :center
                  caption category.description
                end
              end.subscribe(:clicked_left_mouse_button) do
                pop_state
                @options[:callback]&.call(category)
              end
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
