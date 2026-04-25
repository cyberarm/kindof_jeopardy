begin
  require_relative "../cyberarm_engine/lib/cyberarm_engine"
rescue LoadError
  require "cyberarm_engine"
end
require "json"

require_relative "lib/version"
require_relative "lib/theme"
require_relative "lib/window"
require_relative "lib/state"
require_relative "lib/states/main_menu"
require_relative "lib/states/quiz_select_menu"
require_relative "lib/states/pause_menu"
require_relative "lib/states/setup_game"
require_relative "lib/states/game"

module CyberarmEngine
  GUI_DEBUG = false
end

module KindOfJeopardy
  DEBUG = true
end

if KindOfJeopardy::DEBUG
  KindOfJeopardy::Window.new(width: 1280, height: 800, fullscreen: false, resizable: true).show
else
  KindOfJeopardy::Window.new(width: Gosu.screen_width, height: Gosu.screen_height, fullscreen: true, resizable: true).show
end
