module KindOfJeopardy
  class Window < CyberarmEngine::Window
    attr_accessor :socket

    def setup
      @socket = nil

      self.caption = KindOfJeopardy::NAME
      # push_state(States::GameDirector)
      push_state(States::MainMenu)
      # push_state(States::Game)
    end

    def update
      super

      @socket&.update(0)
    end

    def needs_redraw?
      @states.any?(&:needs_redraw?)
    end

    def gain_focus
      super

      self.update_interval = 1000.0 / 60
    end

    def lose_focus
      super

      self.update_interval = 1000.0 / 24
    end
  end
end
