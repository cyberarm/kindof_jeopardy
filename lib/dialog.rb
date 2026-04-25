module KindOfJeopardy
  class Dialog < CyberarmEngine::Dialog
    def setup
      self.show_cursor = true

      theme(KindOfJeopardy::THEME)
    end
  end
end
