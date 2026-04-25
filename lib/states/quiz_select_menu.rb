module KindOfJeopardy
  class States
    class QuizSelectMenu < KindOfJeopardy::State
      def setup
        super

        @data = JSON.parse(File.read("./data/sample.jsonc"), symbolize_names: true)

        flow(width: 1.0, height: 1.0) do
          @data[:categories].each do |cat|
            stack(fill: true, height: 1.0) do
              button cat[:name].to_s, width: 1.0, fill: true, enabled: false

              cat[:questions].each do |question|
                button question[:label].to_s, width: 1.0, fill: true, enabled: true
              end
            end
          end
        end
      end
    end
  end
end
