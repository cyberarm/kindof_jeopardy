module KindOfJeopardy
  class States
    class GameDirector < KindOfJeopardy::State
      LED_BRIGHTNESS = 14

      def setup
        super

        @context = @options[:context] || States::Game::Context.new

        @server = KindOfJeopardy::Networking::Server.new(host: "0.0.0.0", port: 56789, max_clients: 32, channels: 1)
        @server.use_compression(true)
        window.socket = @server

        @cone_light_controller = nil
        setup_cone_light_controller

        @turn = nil

        # broadcast game state every n seconds so game viewers can "connect"
        every(1_000) do
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
              @turn_history = stack(width: 1.0, fill: true, scroll: true, padding: PADDING) do
              end
              36.times do |i|
                add_turn(nil)
              end
            end

            # game questions
            @questions_container = stack(fill: true, height: 1.0) do
              background GAME_BACKGROUND
            end
            populate_questions
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

      def update
        super

        service_cone_light_controller
      end

      def setup_cone_light_controller
        dev = Dir.glob("/dev/ttyACM*").first

        @cone_light_controller = SerialPort.open(dev, 115200)
        sleep 0.001
        cone_light_net_color(QUESTION_BACKGROUND, 255, true)
      end

      def service_cone_light_controller
        data = @cone_light_controller.read_nonblock(256)
        return unless data.start_with?("big_red_button")

        _app, protocol_id, firmware_version, packet_id, timestamp, node_id, node_name, node_group_id, command_id, command_type, command_parameters, command_parameters_extra = data.split(":")
        # @context.state[:state] = :ready_for_answers
        pp data
        if true && (team = @context.teams[node_id.to_i])
          pp team
          acknowledge_team(team)
        end
      rescue IO::EAGAINWaitReadable
      end

      def populate_questions
        @questions_container.clear do
          flow(width: 1.0, fill: true) do
            @context.categories.each do |category|
              next unless category

              stack(fill: true, height: 1.0) do
                button category.name, width: 1.0, fill: true, text_size: 24, style_class: [:jeopardy_header], margin_bottom: HALF_PADDING

                category.questions.each_with_index do |question, i|
                  next unless i.positive?

                  button @context.options[:"answer_score_row_#{i}"] * @context.options[:score_multiplier], width: 1.0, fill: true, text_size: 24, style_class: [:jeopardy_button] do
                    show_question(question)
                  end
                end
              end
            end
          end
        end
      end

      def show_question(question)
        @questions_container.clear do
          stack(width: 1.0, v_align: :center) do
            banner question.question.upcase, width: 1.0, text_align: :center
            title question.answer, color: 0xaa_ffffff, width: 1.0, text_align: :center, margin_top: LARGE_PADDING
            tagline question.host_context, color: 0xaa_ffffff, width: 1.0, text_align: :center, margin_top: LARGE_PADDING
          end
        end
      end

      def add_turn(turn)
        @turn_history.append do
          flow(width: 1.0, padding: HALF_PADDING, margin_bottom: HALF_PADDING, background_nine_slice_color: 0x44_111111, background_nine_slice: NINE_SLICE_BACKGROUND) do
            # turn id
            caption format("%2d", 0)
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

      def cone_light_net_color(color, node_or_group_id, is_group = false)
        color = color.is_a?(Gosu::Color) ? color : Gosu::Color.new(color)
        pp color

        command = "net_color #{color.red} #{color.green} #{color.blue} #{LED_BRIGHTNESS} #{node_or_group_id} #{is_group}"
        pp command
        @cone_light_controller.puts(command)
        sleep 0.01 # sleep main thread while sending stuff
        @cone_light_controller.puts(command)
        sleep 0.01 # sleep main thread while sending stuff
        @cone_light_controller.puts(command)
        sleep 0.01 # sleep main thread while sending stuff
      end

      # STATES STUFF
      # :choose_question, :show_question, :ready_for_answers, :acknowledge_team, :, :reject_answer, :accept_answer

      def choose_question(question)

      end

      def ready_for_answers
      end

      def acknowledge_team(team)
        cone_light_net_color(Gosu::Color::BLACK, 255, true)
        cone_light_net_color(TEAM_COLORS[team.color], @context.teams.index(team), false)
      end

      def reject_answer
      end

      def accept_answer
      end
    end
  end
end
