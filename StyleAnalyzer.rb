#!/usr/bin/ruby
# frozen_string_literal: true

require 'csv'
require 'colorize'
require 'titleize'
require 'pry'
require 'ruby-progressbar'
require 'nokogiri'
require 'active_support/all'
require 'css_parser'

%w[
  models
  support
].each do |dir|
  Dir.open(dir).each do |file_name|
    next unless file_name =~ /\.rb$/

    require_relative "#{dir}/#{file_name}"
  end
end

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
