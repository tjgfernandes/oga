require 'spec_helper'

describe Oga::XML::Lexer do
  context 'HTML void elements' do
    example 'lex a void element that omits the closing /' do
      lex('<link>', :html => true).should == [
        [:T_ELEM_START, nil, 1],
        [:T_ELEM_NAME, 'link', 1],
        [:T_ELEM_END, nil, 1]
      ]
    end

    example 'lex text after a void element' do
      lex('<link>foo', :html => true).should == [
        [:T_ELEM_START, nil, 1],
        [:T_ELEM_NAME, 'link', 1],
        [:T_ELEM_END, nil, 1],
        [:T_TEXT, 'foo', 1]
      ]
    end

    example 'lex a void element inside another element' do
      lex('<head><link></head>', :html => true).should == [
        [:T_ELEM_START, nil, 1],
        [:T_ELEM_NAME, 'head', 1],
        [:T_ELEM_START, nil, 1],
        [:T_ELEM_NAME, 'link', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_END, nil, 1]
      ]
    end

    example 'lex a void element inside another element with whitespace' do
      lex("<head><link>\n</head>", :html => true).should == [
        [:T_ELEM_START, nil, 1],
        [:T_ELEM_NAME, 'head', 1],
        [:T_ELEM_START, nil, 1],
        [:T_ELEM_NAME, 'link', 1],
        [:T_ELEM_END, nil, 1],
        [:T_TEXT, "\n", 1],
        [:T_ELEM_END, nil, 2]
      ]
    end
  end
end
