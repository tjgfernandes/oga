require 'spec_helper'

describe Oga::XML::Querying do
  before do
    @document = parse('<a>foo</a>')
    @document2 = parse('<a xmlns:x="y"><x:b>bar</x:b></a>')
    @namespaces = {
      "n" => "y"
    }
  end

  describe '#xpath' do
    it 'queries a document' do
      expect(@document.xpath('a')[0].name).to eq('a')
    end

    it 'queries an element' do
      expect(@document.children[0].xpath('text()')[0].text).to eq('foo')
    end

    it 'evaluates an expression using a variable' do
      expect(@document.xpath('$number', 'number' => 10)).to eq(10)
    end

    it 'respects custom namespace aliases' do
      expect(@document2.xpath('a/n:b', namespaces: @namespaces)[0].text).to eq('bar')
    end
  end

  describe '#at_xpath' do
    it 'queries a document' do
      expect(@document.at_xpath('a').name).to eq('a')
    end

    it 'queries an element' do
      expect(@document.children[0].at_xpath('text()').text).to eq('foo')
    end

    it 'evaluates an expression using a variable' do
      expect(@document.at_xpath('$number', 'number' => 10)).to eq(10)
    end

    it 'respects custom namespace aliases' do
      expect(@document2.at_xpath('a/n:b', namespaces: @namespaces).text).to eq('bar')
    end
  end

  describe '#css' do
    it 'queries a document' do
      expect(@document.css('a')).to eq(@document.children)
    end
  end

  describe '#at_css' do
    it 'queries a document' do
      expect(@document.at_css('a')).to eq(@document.children[0])
    end
  end
end
