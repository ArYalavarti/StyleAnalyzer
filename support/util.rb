# frozen_string_literal: true

# Util module for helper functions
module Util
  def self.write_welcome_message
    msg = "Welcome to \u{1F680} StyleAnalyzer \u{1F680}, a HTML/CSS"\
          ' static-analyzer'

    puts(('-' * (msg.length + 4)).colorize(:blue))
    puts(" #{msg}".colorize(:blue))
    puts(('-' * (msg.length + 4)).colorize(:blue))

    puts "\n\n"
  end

  def self.get_relative_filepath
    puts 'Enter the relative filepath to the root directory of the'\
          ' project you want to analyze. Ex: \'../../dev/UI\''

    gets.chomp
  end

  def self.parse_html_file(file_path)
    file_data   = File.open(file_path).read
    parsed_data = Nokogiri.parse(file_data)
    depth_search(node: parsed_data, css_classes: {})
  end

  def self.depth_search(node:, css_classes:)
    node.children.each do |child|
      unless child.attributes.empty?
        check_css_attributes(attr: ["id", "class"],
                             css_classes: css_classes,
                             child: child)
      end
      depth_search(node: child, css_classes: css_classes)
    end
    css_classes
  end

  def self.check_css_attributes(attr:, css_classes:, child:)
    attr.each do |att|
      unless child.attributes[att].nil?
        css_classes[att] = {} if css_classes[att].nil?
        css_classes[att][child.attributes[att].value] = true
      end
    end
  end
end
