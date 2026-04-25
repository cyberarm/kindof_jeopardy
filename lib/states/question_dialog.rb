module KindOfJeopardy
  class States
    class QuestionDialog < KindOfJeopardy::Dialog
      def setup
        super

        @question = @options[:question]
        @button = @options[:button]

        stack(width: 1.0, height: 1.0, padding: LARGE_PADDING, background: QUESTION_BACKGROUND) do
          # @question.label
          banner "Hello world, what is the meaning of the life and everything in general?", text_size: 96, width: 1.0, fill: true, padding: LARGE_PADDING, text_align: :center, text_v_align: :center
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
