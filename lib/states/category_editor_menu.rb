module KindOfJeopardy
  class States
    class CategoryEditorMenu < KindOfJeopardy::State
      def setup
        super

        background 0xff_353535

        flow(width: 1.0, height: 1.0) do
          stack(width: 0.5, max_width: 480, height: 1.0, padding: PADDING) do
            banner "Category Editor Menu", width: 1.0, text_align: :center

            button "Create Category", width: 1.0, margin_top: LARGE_PADDING do
              pop_state
              push_state(States::CategoryEditor)
            end

            button "Main Menu", width: 1.0, margin_top: PADDING do
              pop_state
              push_state(States::MainMenu)
            end
          end

          stack(fill: true, height: 1.0, padding: PADDING) do
            title "Categories", width: 1.0, text_align: :center

            flow(width: 1.0) do
              edit_line "", fill: true
              button "Search"
            end

            stack(width: 1.0, fill: true, scroll: true, margin_top: LARGE_PADDING) do
              available_categories.each do |category|
                button category.name, width: 1.0
              end
            end
          end
        end
      end

      def available_categories
        categories = []

        Dir.glob("#{ROOT_PATH}/data/*.json").sort_by { |a| a.downcase }.each do |file|
          categories << JSON.parse(File.read(file))
        rescue JSON::ParserError
        end

        categories
      end
    end
  end
end
