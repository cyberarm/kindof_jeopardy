module KindOfJeopardy
  class Window < CyberarmEngine::Window
    def setup
      self.caption = KindOfJeopardy::NAME
      push_state(States::MainMenu)
      # push_state(States::Game)
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
