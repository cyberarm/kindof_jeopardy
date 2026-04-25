module KindOfJeopardy
  QUARTER_PADDING = 5
  HALF_PADDING = 10
  PADDING = 20
  LARGE_PADDING = 40

  GAME_BACKGROUND = [0xaa_1a5fb4, 0x44_1a5fb4, 0x44_1a5fb4, 0xaa_1a5fb4]
  QUESTION_BACKGROUND = 0xee_1a5fb4
  GAME_BUTTON_BACKGROUND = 0xaa_1a5fb4
  GAME_BUTTON_BACKGROUND_HOVER = 0xff_1a5fb4
  GAME_BUTTON_BACKGROUND_ACTIVE = 0x88_1a5fb4
  GAME_BUTTON_BACKGROUND_DISABLED = 0x44_1a5fb4
  NINE_SLICE_BACKGROUND = "#{ROOT_PATH}/media/ui/rounded_small.png"
  NINE_SLICE_EDGE = 4

  THEME = {
    Element: {
      background_nine_slice_from_edge: NINE_SLICE_EDGE,
      background_nine_slice_mode: :stretched
    },
    TextBlock: {
      text_static: true,
      font: "#{ROOT_PATH}/media/fonts/NotoSans-Regular.ttf"
    },
    Banner: {
      font: "#{ROOT_PATH}/media/fonts/NotoSans-Black.ttf"
    },
    Title: {
      font: "#{ROOT_PATH}/media/fonts/NotoSans-Black.ttf"
    },
    Subtitle: {
      font: "#{ROOT_PATH}/media/fonts/NotoSans-Black.ttf"
    },
    Tagline: {
      font: "#{ROOT_PATH}/media/fonts/NotoSans-Black.ttf"
    },
    Button: {
      font: "#{ROOT_PATH}/media/fonts/NotoSans-Black.ttf",
      text_align: :center,
      border_thickness: 0,
      margin: QUARTER_PADDING,
      background_nine_slice: NINE_SLICE_BACKGROUND,
      background_nine_slice_color: 0xaa_ff8800,
      background: 0,
      hover: {
        background: 0
      },
      active: {
        background: 0
      },
      disabled: {
        background: 0
      }
    },
    ToggleButton: {
      checkmark: "Yes"
    },
    jeopardy_header: {
      padding: HALF_PADDING,
      text_wrap: :word_wrap,
      color: 0xff_ffffff,
      text_size: 32,
      background_nine_slice_color: GAME_BUTTON_BACKGROUND,
      hover: {
        color: 0xff_ffffff,
        background_nine_slice_color: GAME_BUTTON_BACKGROUND
      },
      active: {
        color: 0xff_ffffff,
        background_nine_slice_color: GAME_BUTTON_BACKGROUND
      },
      disabled: {
        color: 0,
        background_nine_slice_color: GAME_BUTTON_BACKGROUND
      }
    },
    jeopardy_button: {
      padding: HALF_PADDING,
      color: 0xff_e5a50a,
      text_shadow: true,
      text_shadow_color: 0xaa_000000,
      text_size: 64,
      background_nine_slice_color: GAME_BUTTON_BACKGROUND,
      border_color: 0xff_000000,
      hover: {
        color: 0xff_f9f06b,
        background_nine_slice_color: GAME_BUTTON_BACKGROUND_HOVER
      },
      active: {
        color: 0xff_ff7800,
        background_nine_slice_color: GAME_BUTTON_BACKGROUND_ACTIVE
      },
      disabled: {
        color: 0,
        text_shadow_color: 0,
        background: 0,
        background_nine_slice_color: GAME_BUTTON_BACKGROUND_DISABLED
      }
    }
  }
end
