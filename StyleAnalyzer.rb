#!/usr/bin/ruby
# frozen_string_literal: true

require 'csv'
require 'colorize'
require 'titleize'
require 'pry'
require 'ruby-progressbar'
require 'nokogiri'

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

filepath = Util.get_relative_filepath
puts 'Analyzing HTML files.'.colorize(:green)

active_css_class = {}

Dir.glob("#{filepath}/**/**").each do |f|
  next unless f =~ /\.html$/
  # Util.parse_html_file(f)
end


