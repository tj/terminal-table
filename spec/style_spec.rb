# encoding: utf-8
require 'spec_helper'

module Terminal
  describe Table::Style do
    
    before :each do
      @table = Table.new
    end

    border_map = {
      :markdown => Terminal::Table::MarkdownBorder,
      :ascii => Terminal::Table::AsciiBorder,
      :unicode => Terminal::Table::UnicodeBorder,
      :unicode_thick_edge => Terminal::Table::UnicodeThickEdgeBorder,
      :unicode_round => Terminal::Table::UnicodeRoundBorder,
    }
    
    border_map.each do |name_sym, klass|
      it "should enumerate a #{name_sym} table" do
        @table.style.border = name_sym
        @table.style.border.should be_a klass
        @table.style.border = klass.new
        @table.style.border.should be_a klass
      end
    end
    
  end
end
