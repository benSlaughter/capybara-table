require 'hashie'
require 'capybara'
require 'capybara/dsl'

class Table
  include Capybara::DSL

  def initialize element = "table"
    @element = element
    parse_table
    parse_headers
    parse_rows
  end

  def parse_table
    @table = all("#{@element} > tbody > tr").map{ |h| h.all("td").map{| e| e.text } }
  end

  def parse_headers
    @headers = Hashie::Mash.new
    @header_rows = Hashie::Mash.new
    all("table > thead > tr").map{ |h| h.all "th" }.each do | header_row |
      index = 0
      header_row.each_with_index do | header, index |
        @headers[header.text] ||= []
        (header["colspan"] ? header["colspan"].to_i : 1).times do
          @headers[header.text].push index
          index += 1
        end
      end
    end
  end

  def parse_rows
    @row_headers = Hashie::Mash.new
    all("#{@element} > tbody > tr").each_with_index{ |r,i| @row_headers[r.find("td:first-child").text] = i }
  end

  def get_info row, columns
    columns = columns.map{|c| @headers[c] }.inject(:&)
    row = @row_headers[row]

    temp = []
    columns.each do |column_index|
      temp.push @table[row][column_index]
    end

    temp
  end

  def row number
    @table[number]
  end

  def column number
    @headers.inject([]) { |sum,h| h[1].include?(number) ? sum.push(h[0]) : sum} + @table.map {|r| r[number]}
  end

  def width
    row(0).length
  end

  def height
    column(0).length
  end

  def [] number
    @table.map {|r| r[number]}
  end
end