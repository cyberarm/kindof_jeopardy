module KindOfJeopardy
  class States
    class Game < KindOfJeopardy::State
      Team = Struct.new(:name, :color) do
        def self.from_json(hash)
          Team.new(**hash)
        end

        def to_json(context = nil)
          to_h.to_json(context)
        end
      end
      Category = Struct.new(:name, :description, :questions) do
        def self.from_json(hash)
          raise NotImplementedError
        end

        def to_json(context = nil)
          to_h.to_json(context)
        end
      end
      Question = Struct.new(:type, :uri, :question, :answer, :host_context) do
        def self.from_json(hash)
          Question.new(**hash)
        end

        def to_json(context = nil)
          to_h.to_json(context)
        end
      end

      # ID of category from Context, row index of question, array of
      Turn = Struct.new(:category_id, :row, :team_attempts, :accepted_team, :time) do
        def self.from_json(hash)
          raise NotImplementedError
        end

        def to_json(context = nil)
          to_h.to_json(context)
        end
      end

      Context = Struct.new(:teams, :categories, :options, :turns) do
        def self.from_json(hash)
          raise NotImplementedError
        end

        def to_json(context = nil)
          to_h.to_json(context)
        end
      end

      def setup
        super

        @context = @options[:context]
        # FIXME: don't overwrite the categories, once we have real categories to work with xD
        @context.categories.each_with_index do |cat, i|
          @context.categories[i] = Category.new(
            "Super Secret",
            "",
            [
              Question.new("text", "ZERO", "VALUE", "HINT"),
              Question.new("text", "ZERO", "VALUE", "HINT"),
              Question.new("text", "ZERO", "VALUE", "HINT"),
              Question.new("text", "ZERO", "VALUE", "HINT"),
              Question.new("text", "ZERO", "VALUE", "HINT")
            ]
          )
        end

        flow(width: 1.0, height: 1.0, padding: HALF_PADDING, background: GAME_BACKGROUND) do
          @context.categories.each do |category|
            next unless category

            stack(fill: true, height: 1.0) do
              # category
              guessable = @context.options[:categories_guessable]
              button(guessable ? "?" : category.name.to_s.upcase, width: 1.0, fill: true, style_class: (guessable ? [:jeopardy_button] : [:jeopardy_button, :jeopardy_header]), margin_bottom: HALF_PADDING) do |btn|
                next unless guessable

                btn.enabled = false
                dialog(QuestionDialog, question: question, button: btn)
              end

              # quiz item
              category.questions.each_with_index do |question, i|
                # question.label.to_s
                button @context.options[:"answer_score_row_#{i + 1}"] * @context.options[:score_multiplier], width: 1.0, fill: true, style_class: [:jeopardy_button] do |btn|
                  btn.enabled = false
                  dialog(QuestionDialog, question: question, button: btn)
                end
              end
            end
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
