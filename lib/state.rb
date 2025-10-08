module Jeopardy
  class State < CyberarmEngine::GuiState
    def setup
      self.show_cursor = true

      theme(Jeopardy::THEME)
    end
  end
end
