require 'roor/excelx'

module ExcelHelpers

  # Merges values of entire row
  #
  def row(r)
    vals = (book.first_column .. book.last_column).map do |c|
      book.cell(r, c)
    end
  end

  # Returns an array of values for the cells in the given range
  #
  def cells(rows, columns)
    Array(rows).map do |r|
      Array(columns).map do |c|
        cell(r, c)
      end
    end.flatten(1)
  end

  # Returns the value of the cell at the given location
  #
  def cell(row, column)
    book.cell(row, column)
  end

  # Returns true if the cell at the given location is a formula, or false otherwise
  #
  def formula?(row, column)
    book.formula?(row, column)
  end

  # Gets the formula at the given location
  #
  def formula(row, column)
    book.formula(row, column)
  end

  # A debug helper - opens up the tempfile generated with rendering the book
  # (assumes that there is a method/let called tempfile that returns the path)
  #
  def show_me(app = "OpenOffice.org")
    report_xls
    system "open -a #{app}.app #{tempfile}"
  end

end
