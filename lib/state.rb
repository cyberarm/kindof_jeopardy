module KindOfJeopardy
  class State < CyberarmEngine::GuiState
    def setup
      self.show_cursor = true

      theme(KindOfJeopardy::THEME)
    end
  end
end
