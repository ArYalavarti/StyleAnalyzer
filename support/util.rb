# frozen_string_literal: true

# Util module for helper functions
module Util
  def self.write_welcome_message
    msg = "Welcome to \u{1F680} StyleAnalyzer \u{1F680}, a HTML/CSS"\
          ' static-analyzer'

    puts ("-" * (msg.length + 4)).colorize(:blue)
    puts (" #{msg}").colorize(:blue)
    puts ("-" * (msg.length + 4)).colorize(:blue)

    puts "\n\n"
  end

  def self.get_relative_filepath
    puts 'Enter the relative filepath to the root directory of the'\
          ' project you want to analyze. Ex: \'../../dev/UI\''

    gets.chomp
  end
end
