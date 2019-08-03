#!/usr/bin/ruby
# frozen_string_literal: true

require 'csv'
require 'colorize'
require 'titleize'
require 'pry'
require 'ruby-progressbar'
require 'nokogiri'
require 'active_support/all'

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

active_css_classes = {}

Dir.glob("#{filepath}/**/**").each do |f|
  next unless f =~ /\.html$/

  active_css_classes.deep_merge!(Util.parse_html_file(f))
end

puts active_css_classes