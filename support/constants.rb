# frozen_string_literal: true

module Constants
  WELCOME_MSG  = "Welcome to \u{1F3A8} StyleAnalyzer \u{1F3A8}, a HTML/CSS"\
          ' static-analyzer'

  FILEPATH_MSG = "\nEnter the" + ' relative filepath '.colorize(:blue) +
                 'to the root directory of '\
                 'the project you want to analyze. Ex: ' +
                 '\'../../dev/UI\''.colorize(:blue)

  ATTRIBUTES   = { id: '#', class: '.' }.stringify_keys.freeze
end
