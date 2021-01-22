# frozen_string_literal: true

# Util module for helper functions
module Util
  def self.write_welcome_message
    puts(('-' * (Constants::WELCOME_MSG.length + 4)).colorize(:blue))
    puts(" #{Constants::WELCOME_MSG}".colorize(:blue))
    puts(('-' * (Constants::WELCOME_MSG.length + 4)).colorize(:blue))
  end

  def self.read_relative_filepath
    puts Constants::FILEPATH_MSG
    ask "> "
  end

  def self.skip_css_file(file:)
    puts(file.colorize(:blue))
    puts('Type ' + 'SKIP'.colorize(:blue) +
             ' to skip parsing this CSS file. Press ' +
             'ENTER'.colorize(:blue) + ' otherwise.')
    (ask "> ").chomp == 'SKIP'
  end

  def self.parse_html_file(file_path:)
    file_data   = File.open(file_path).read
    parsed_data = Nokogiri.parse(file_data)
    depth_search(node: parsed_data, css_classes: {})
  end

  def self.depth_search(node:, css_classes:)
    node.children.each do |child|
      unless child.attributes.empty?
        check_css_attributes(attr: Constants::ATTRIBUTES.keys,
                             css_classes: css_classes,
                             child: child)
      end
      depth_search(node: child, css_classes: css_classes)
    end
    css_classes
  end

  def self.check_css_attributes(attr:, css_classes:, child:)
    attr.each do |att|
      next if child.attributes[att].nil?

      css_classes[att] = {} if css_classes[att].nil?

      child.attributes[att].value.split(' ').each do |attribute|
        css_classes[att][attribute] = true
      end
    end
  end

  def self.parse_css_file(file_path:)
    parser      = CssParser::Parser.new
    css_classes = {}
    parser.load_uri!(file_path)
    parser.each_selector do |selector|
      css_classes.deep_merge!(analyze_selector_group(selector: selector))
    end
    css_classes
  end

  def self.analyze_selector_group(selector:)
    css_classes = {}
    Constants::ATTRIBUTES.values.each { |x| css_classes[x] = {} }

    valid_selectors = selector.split(/[ >,]/).select do |elem|
      Constants::ATTRIBUTES.values.reduce(false) do |acc, cur|
        acc || elem.strip.start_with?(cur)
      end
    end

    valid_selectors.each do |x|
      analyze_selector(css_classes: css_classes,
                       selector: x)
    end

    css_classes
  end

  def self.analyze_selector(css_classes:, selector:)
    sub_selector = ''
    cur_attr     = nil

    selector.strip.split('').each do |char|
      if Constants::ATTRIBUTES.values.include?(char)
        register_selector(attr: cur_attr, selector: sub_selector, classes: css_classes)
        cur_attr = char
        sub_selector = ''
      else
        sub_selector += char
      end
    end

    register_selector(attr: cur_attr, selector: sub_selector, classes: css_classes)
  end

  def self.register_selector(attr:, selector:, classes:)
    classes[attr][selector.split(/[:\[]/).first.strip] = true unless attr.nil?
  end

  def self.print_unused_css_classes(active:, implemented:)
    unused_css_classes = []

    implemented.each_value do |attribute_lists|
      attribute_lists.each do |attr, used|
        unused_css_classes.append(attr) unless
            active.each_value
                  .reduce(false) { |acc, cur| acc || cur[attr].present? }
      end
    end

    puts unused_css_classes
  end
end
