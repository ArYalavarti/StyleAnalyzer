#!/usr/bin/ruby
# frozen_string_literal: true

require 'nokogiri'
require 'colorize'
require 'css_parser'
require 'pry'
require 'active_support/all'

require_relative "support/constants.rb"
require_relative "support/util.rb"

Util.write_welcome_message

filepath = Util.read_relative_filepath
puts 'Analyzing HTML files.'.colorize(:green)

active_css_classes      = {}
implemented_css_classes = {}

Dir.glob("#{filepath}/**/**").each do |f|
  if f =~ /\.html$/
    active_css_classes.deep_merge!(
      Util.parse_html_file(file_path: f)
    )
    next
  end

  next unless f =~ /\.css$/
  #next if Util.skip_css_file(file: f)

  implemented_css_classes.deep_merge!(
    Util.parse_css_file(file_path: f)
  )
end

Util.print_unused_css_classes(active: active_css_classes,
                              implemented: implemented_css_classes)
