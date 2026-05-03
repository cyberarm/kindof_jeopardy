require "socket"

begin
  require_relative "../cyberarm_engine/lib/cyberarm_engine"
rescue LoadError
  require "cyberarm_engine"
end
require "json"
require "faker"
require "ffi-enet"
require "ffi-enet/renet"
require "serialport"

module CyberarmEngine
  GUI_DEBUG = false
end

module KindOfJeopardy
  ROOT_PATH = Dir.pwd

  ITEMS_PER_ROW = 6

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

  CATEGORIES = []

  DEBUG = true

  def self.load_categories!
    categories = "#{ROOT_PATH}/data/categories.json"

    CATEGORIES.clear

    if File.exist?(categories)
      array = JSON.parse(File.read(categories), symbolize_names: true)
      categories = array.map { |hash| States::Game::Category.from_json(hash) }

      CATEGORIES.push(*categories)
    end
  end

  def self.save_categories!
    pp CATEGORIES

    categories = "#{ROOT_PATH}/data/categories.json"
    categories_backup = "#{ROOT_PATH}/data/categories.json.bak"

    # create backup
    File.write(categories_backup, File.read(categories)) if File.exist?(categories)

    # write changes
    File.write(categories, JSON.pretty_generate(CATEGORIES))

    # remove backup
    File.delete(categories_backup) if File.exist?(categories_backup)
  end
end

require_relative "lib/version"
require_relative "lib/theme"
require_relative "lib/window"
require_relative "lib/state"
require_relative "lib/dialog"

require_relative "lib/networking/server"
require_relative "lib/networking/client"

require_relative "lib/states/main_menu"
require_relative "lib/states/pause_menu"
require_relative "lib/states/category_editor_menu"
require_relative "lib/states/category_editor"
require_relative "lib/states/category_selection_dialog"
require_relative "lib/states/team_dialog"
require_relative "lib/states/question_dialog"
require_relative "lib/states/setup_game"
require_relative "lib/states/game"
require_relative "lib/states/game_director_menu"
require_relative "lib/states/connecting"
require_relative "lib/states/game_director"

KindOfJeopardy.load_categories!

if KindOfJeopardy::DEBUG
  KindOfJeopardy::Window.new(width: 1280, height: 800, fullscreen: false, resizable: true).show
else
  KindOfJeopardy::Window.new(width: Gosu.screen_width, height: Gosu.screen_height, fullscreen: true, resizable: true).show
end
