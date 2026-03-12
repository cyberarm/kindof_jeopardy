module Jeopardy
  class Window < CyberarmEngine::Window
    def setup
      self.caption = Jeopardy::NAME
      push_state(States::MainMenu)
    end
  end
end
