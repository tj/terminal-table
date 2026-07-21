require 'spec_helper'

describe Terminal::Table::Util do
  Util = Terminal::Table::Util

  it "should strip ANSI colour escape sequences" do
    Util.ansi_escape("\e[31mfoo\e[0m").should eq 'foo'
  end

  it "should strip OSC 8 hyperlink escape sequences terminated by BEL" do
    hyperlink = "\e]8;;http://example.com\adisplay text\e]8;;\a"
    Util.ansi_escape(hyperlink).should eq 'display text'
  end

  it "should strip OSC 8 hyperlink escape sequences terminated by ST (ESC \\)" do
    hyperlink = "\e]8;;http://example.com\e\\display text\e]8;;\e\\"
    Util.ansi_escape(hyperlink).should eq 'display text'
  end

  it "should strip OSC 8 hyperlinks combined with ANSI colour codes" do
    hyperlink = "\e]8;;http://example.com\a\e[34mdisplay text\e[0m\e]8;;\a"
    Util.ansi_escape(hyperlink).should eq 'display text'
  end
end
