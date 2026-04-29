module KindOfJeopardy
  class States
    class CategoryEditor < KindOfJeopardy::State
      def setup
        super

        @category = @options[:category] || create_default_category
        @initial_category_json = @category.to_json

        background 0xff_353535

        flow(width: 1.0, height: 1.0) do
          stack(width: 0.5, max_width: 480, height: 1.0, padding: PADDING) do
            banner "Category Editor", width: 1.0, text_align: :center

            @save_button = button "Save Category", width: 1.0, margin_top: LARGE_PADDING do
              unless CATEGORIES.find { |c| c == @category }
                CATEGORIES << @category
              end

              KindOfJeopardy.save_categories!

              pop_state
              push_state(CategoryEditorMenu)
            end

            button "Back", width: 1.0, margin_top: PADDING do
              # FIXME: Prompt to confirm discarding changes.
              # next if category_changed?

              pop_state
              push_state(CategoryEditorMenu)
              pp @category
              puts @category.to_json
            end
          end

          stack(fill: true, height: 1.0, padding: PADDING, scroll: true) do
            title "Category", width: 1.0, text_align: :center
            stack(width: 1.0, margin_bottom: PADDING, padding: PADDING, background_nine_slice: NINE_SLICE_BACKGROUND, background_nine_slice_color: 0x22_000000) do
              subtitle "Name"
              edit_line(@category.name, width: 1.0).subscribe(:changed) do |e|
                @category.name = e.value

                a = find_element_by_tag(e.root, :answer_0)
                a.value = format("What is \"%s?\"", e.value)
              end
              subtitle "Description"
              edit_line(@category.description, width: 1.0).subscribe(:changed) do |e|
                @category.description = e.value
              end
            end

            subtitle "Questions", width: 1.0, text_align: :center, margin_top: PADDING
            @category.questions.each_with_index do |question, i|
              stack(width: 1.0, margin_bottom: PADDING, padding: PADDING, background_nine_slice: NINE_SLICE_BACKGROUND, background_nine_slice_color: 0x22_000000) do
                tagline "Question #{i}#{i.zero? ? ' / Guessable Category' : ''}"

                # FIXME: Reenable once non-text only questions are supported.
                # caption "Type"
                # list_box items: ["text"], choose: question.type, width: 1.0, enabled: false do |value|
                #   question.type = value
                # end

                caption "Question", tip: "Required: Question player must answer in question form.\ne.g. \"This famous 20th century singer sang: \<SONG>\""
                edit_line(question.question, width: 1.0, tag: :"question_#{i}").subscribe(:changed) do |e|
                  question.question = e.value
                end

                caption "Answer", tip: "Required: Answer in the form of a question.\ne.g. \"Who is Frank Sinatra?\""
                edit_line(question.answer, width: 1.0, tag: :"answer_#{i}", enabled: i.positive?).subscribe(:changed) do |e|
                  question.answer = e.value
                end

                caption "Host Context", tip: "Optional: Give Host context of question in order better accept an inexact answer."
                edit_line(question.host_context, width: 1.0, tag: :"host_context_#{i}").subscribe(:changed) do |e|
                  question.host_context = e.value
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

      def button_down(id)
        super

        # Debug prints
        if id == Gosu::KB_F1
          pp @category
          puts JSON.pretty_generate(@category)
        end
      end

      def create_default_category
        c = Game::Category.new("", "", [])

        6.times do
          c.questions << Game::Question.new("text", "", "", "", "")
        end

        c
      end

      def category_valid?
        @category.name.length.positive? &&
        @category.description.length.positive? &&
        @category.questions.all? do |q|
          q.type.length.positive? &&
          q.question.length.positive? &&
          q.answer.length.positive?
        end
      end

      def category_changed?
        @category.to_json != @initial_category_json
      end
    end
  end
end
