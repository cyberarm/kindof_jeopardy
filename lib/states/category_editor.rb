module KindOfJeopardy
  class States
    class CategoryEditor < KindOfJeopardy::State
      def setup
        super

        background 0xff_353535

        flow(width: 1.0, height: 1.0) do
          stack(width: 0.5, max_width: 480, height: 1.0, padding: PADDING) do
            banner "Category Editor", width: 1.0, text_align: :center

            button "Save Category", width: 1.0, margin_top: LARGE_PADDING do
              pop_state
            end

            button "Back", width: 1.0, margin_top: PADDING do
              pop_state
            end
          end

          stack(fill: true, height: 1.0, padding: PADDING) do
            title "Category", width: 1.0, text_align: :center
            edit_line "NAME"
            edit_line "DESCRIPTION"

            subtitle "Questions", width: 1.0, text_align: :center, margin_top: LARGE_PADDING
            stack(width: 1.0, fill: true, scroll: true) do
              6.times do |i|
                button "CATEGORY QUESTION: #{i}", width: 1.0, tip: "Special question for guessing the category" if i.zero?
                button "QUESTION: #{i}", width: 1.0 unless i.zero?
              end
            end
          end
        end
      end
    end
  end
end
