require 'spec_helper.rb'
require 'colorize'
require 'active_support/all'

require_relative '../../support/util.rb'
require_relative '../../support/constants.rb'

describe Util do
  context 'analyze_selector implemented css tests' do
    it 'returns empty {} with non-class or id' do
      expect(Util.analyze_selector_group(selector: 'div, p'))
        .to eq({ '#' => {}, '.' => {} }.deep_stringify_keys)

      expect(Util.analyze_selector_group(selector: 'a'))
        .to eq({ '#' => {}, '.' => {} }.deep_stringify_keys)

      expect(Util.analyze_selector_group(selector: 'div p'))
        .to eq({ '#' => {}, '.' => {} }.deep_stringify_keys)

      expect(Util.analyze_selector_group(selector: 'div > p'))
        .to eq({ '#' => {}, '.' => {} }.deep_stringify_keys)

      expect(Util.analyze_selector_group(selector: 'div + p'))
        .to eq({ '#' => {}, '.' => {} }.deep_stringify_keys)
    end

    it 'single attribute selectors' do
      expect(Util.analyze_selector_group(selector: '.pink'))
        .to eq({ ".": { pink: true }, "#": {} }.deep_stringify_keys)
    end

    it 'combined attribute selectors' do
      expect(Util.analyze_selector_group(selector: '.dropdown-content.mission'))
        .to eq({ ".": {
          "dropdown-content": true,
          "mission": true
        }, "#": {} }.deep_stringify_keys)

      expect(Util.analyze_selector_group(selector: '.dropdown-content.a'))
        .to eq({ ".": {
          "dropdown-content": true,
          "a": true
        }, "#": {} }.deep_stringify_keys)

      expect(Util.analyze_selector_group(selector: '.dropdown-content a'))
        .to eq({ ".": {
          "dropdown-content": true
        }, "#": {} }.deep_stringify_keys)

      expect(Util.analyze_selector_group(selector: '.dropdown-content .a'))
        .to eq({ ".": {
          "dropdown-content": true,
          "a": true
        }, "#": {} }.deep_stringify_keys)

      expect(Util.analyze_selector_group(selector: '.mission #test'))
        .to eq({ ".": {
          "mission": true,
        }, "#": { test: true } }.deep_stringify_keys)


      expect(Util.analyze_selector_group(selector: '.navy-text.left.list'))
        .to eq({ ".": {
          "navy-text": true,
          "left": true,
          "list": true
        }, "#": {} }.deep_stringify_keys)

      expect(Util.analyze_selector_group(selector:
                                             '.navy-text.left.list > .mission'))
        .to eq({ ".": {
          "navy-text": true,
          "left": true,
          "list": true,
          "mission": true
        }, "#": {} }.deep_stringify_keys)

      expect(Util.analyze_selector_group(selector:
                                             '.navy-text.left.list + .mission'))
        .to eq({ ".": {
          "navy-text": true,
          "left": true,
          "list": true,
          "mission": true
        }, "#": {} }.deep_stringify_keys)
    end

    it ': selectors' do
      expect(Util.analyze_selector_group(selector: '.toggle:checked + .label-toggle + .collapsible-content'))
        .to eq({ ".": {
          "toggle": true,
          "label-toggle": true,
          "collapsible-content": true
        }, "#": {} }.deep_stringify_keys)

      expect(Util.analyze_selector_group(selector: 'a:hover'))
        .to eq({ '#' => {}, '.' => {} }.deep_stringify_keys)

      expect(Util.analyze_selector_group(selector: '.test:hover'))
        .to eq({ ".": {
          "test": true
        }, "#": {} }.deep_stringify_keys)
    end

    it '[] selectors' do
      expect(Util.analyze_selector_group(selector: 'div[class$="test"]'))
        .to eq({ '#' => {}, '.' => {} }.deep_stringify_keys)

      expect(Util.analyze_selector_group(selector: '.test[class$="test"]'))
        .to eq({ ".": {
          "test": true,
        }, "#": {} }.deep_stringify_keys)

      expect(Util.analyze_selector_group(selector: '#test[class$="test"]'))
        .to eq({ "#": {
          "test": true,
        }, ".": {} }.deep_stringify_keys)

      expect(Util.analyze_selector_group(selector: '[class$="test"]'))
        .to eq({ '#' => {}, '.' => {} }.deep_stringify_keys)
    end
  end
end
