module Jeopardy
  class States
    class MainMenu < Jeopardy::State
      def setup
        super

        flow(width: 1.0, height: 1.0) do
          6.times do |i|
            stack(fill: true, height: 1.0) do
              5.times do |j|
                button "LABEL", width: 1.0, fill: true, enabled: j != 0
              end
            end
          end
        end
      end
    end
  end
end
