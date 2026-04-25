require "socket"

begin
  require_relative "../cyberarm_engine/lib/cyberarm_engine"
rescue LoadError
  require "cyberarm_engine"
end
require "json"
require "faker"
require "async/websocket"

module CyberarmEngine
  GUI_DEBUG = false
end

module KindOfJeopardy
  ROOT_PATH = Dir.pwd

  DEFAULT_NETWORK_PORT = 56789

  MAX_CATEGORIES = 6
  MAX_TEAMS = 8

  TEAM_COLORS = {
    "blue" => 0xff_1a5fb4,
    "green" => 0xff_26a269,
    "yellow" => 0xff_e5a50a,
    "orange" => 0xff_c64600,
    "red" => 0xff_a51d2d,
    "purple" => 0xff_613583,
    "brown" => 0xff_63452c,
    "black" => 0xff_000000
  }.freeze

  DEBUG = true
end

require_relative "lib/version"
require_relative "lib/theme"
require_relative "lib/window"
require_relative "lib/state"
require_relative "lib/dialog"
require_relative "lib/states/main_menu"
require_relative "lib/states/pause_menu"
require_relative "lib/states/category_editor_menu"
require_relative "lib/states/category_editor"
require_relative "lib/states/category_selection_dialog"
require_relative "lib/states/team_dialog"
require_relative "lib/states/question_dialog"
require_relative "lib/states/setup_game"
require_relative "lib/states/game"

if KindOfJeopardy::DEBUG
  KindOfJeopardy::Window.new(width: 1280, height: 800, fullscreen: false, resizable: true).show
else
  KindOfJeopardy::Window.new(width: Gosu.screen_width, height: Gosu.screen_height, fullscreen: true, resizable: true).show
end
