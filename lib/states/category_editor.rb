module KindOfJeopardy
  class States
    class CategoryEditor < KindOfJeopardy::State
      def setup
        super

        @category = @options[:category] || create_default_category

        background 0xff_353535

        flow(width: 1.0, height: 1.0) do
          stack(width: 0.5, max_width: 480, height: 1.0, padding: PADDING) do
            banner "Category Editor", width: 1.0, text_align: :center

            @save_button = button "Save Category", width: 1.0, margin_top: LARGE_PADDING do
              pop_state
              push_state(CategoryEditorMenu)
              pp @category
              puts @category.to_json
            end

            button "Back", width: 1.0, margin_top: PADDING do
              pop_state
              push_state(CategoryEditorMenu)
              pp @category
              puts @category.to_json
            end
          end

          stack(fill: true, height: 1.0, padding: PADDING) do
            title "Category", width: 1.0, text_align: :center
            stack(width: 1.0, margin_bottom: PADDING, padding: PADDING, background_nine_slice: NINE_SLICE_BACKGROUND, background_nine_slice_color: 0x22_000000) do
              subtitle "Name"
              edit_line @category.name, width: 1.0
              subtitle "Description"
              edit_line @category.description, width: 1.0
            end

            subtitle "Questions", width: 1.0, text_align: :center, margin_top: PADDING
            stack(width: 1.0, fill: true, scroll: true) do
              @category.questions.each_with_index do |question, i|
                stack(width: 1.0, margin_bottom: PADDING, padding: PADDING, background_nine_slice: NINE_SLICE_BACKGROUND, background_nine_slice_color: 0x22_000000) do
                  tagline "Question #{i}#{i.zero? ? ' / Guessable Category' : ''}"

                  caption "Type"
                  list_box items: ["text"], choose: question.type, width: 1.0 do |value|
                    question.type = value
                  end

                  caption "Question", tip: "Required: Question player must answer in question form.\ne.g. \"This famous 20th century singer sang: \<SONG>\""
                  edit_line question.question, width: 1.0 do |e|
                    question.question = e.value
                  end

                  caption "Answer", tip: "Required: Answer in the form of a question.\ne.g. \"Who is Frank Sinatra?\""
                  edit_line question.answer, width: 1.0 do |e|
                    question.answer = e.value
                  end

                  caption "Host Context", tip: "Optional: Give Host context of question in order better accept an inexact answer."
                  edit_line(question.host_context, width: 1.0).subscribe(:changed) do |e|
                    question.host_context = e.value
                  end
                end
              end
            end
          end
        end
      end

      def update
        super

        @save_button.enabled = category_valid?
      end

      def create_default_category
        c = Game::Category.new("", "", [])

        6.times do
          c.questions << Game::Question.new("text", "", "", "", "")
        end

        c
      end

      def category_valid?
        @category.name.length > 0 &&
        @category.description.length > 0 &&
        @category.questions.all? do |q|
          q.type.length > 0 &&
          q.question.length > 0 &&
          q.answer.length > 0
        end
      end
    end
  end
end
