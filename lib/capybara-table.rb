require 'hashie'
require 'capybara'
require 'capybara/dsl'

class Table
  include Capybara::DSL

  def initialize element = "table"
    @element     = element
    @headers     = Hashie::Mash.new
    @row_headers = Hashie::Mash.new

    parse_body
    parse_headers
    parse_row_headers
  end

  def parse_body
    @table_body = all("#{@element} > tbody > tr").map{ |h| h.all("td").map{| e| e.text.downcase } }
  end

  def parse_headers
    all("table > thead > tr").map{ |h| h.all "th" }.each do | header_row |
      column_index = 0
      header_row.each do | header |
        @headers[header.text.downcase] ||= []
        (header["colspan"] ? header["colspan"].to_i : 1).times do
          @headers[header.text.downcase].push column_index

          column_index += 1
        end
      end
    end
  end

  def parse_row_headers
    all("#{@element} > tbody > tr").each_with_index{ |r,i| @row_headers[r.find("td:first-child").text.downcase] = i }
  end

  def get_cells row_name, columns_array
    columns = columns_array.map{|c| @headers[c.downcase] ? @headers[c.downcase] : [] }.inject(:&)
    row = @row_headers[row_name.downcase]
    raise "Could not find row: %s in row headers: %s" % [row_name.downcase, @row_headers] if row.nil?

    temp = []
    columns.each do |column_index|
      temp.push @table_body[row][column_index]
    end

    raise "Unable to find any matching data with row: %s and columns: %s" % [row_name.to_s, columns_array.to_s] if temp.empty?
    temp.length == 1 ? temp.first : temp
  end

  def row number
    @table_body[number]
  end

  def column number
    @headers.inject([]) { |sum,h| h[1].include?(number) ? sum.push(h[0]) : sum} + @table_body.map {|r| r[number]}
  end

  def width
    row(0).length
  end

  def height
    column(0).length
  end

  def [] number
    @table_body.map {|r| r[number]}
  end
end
