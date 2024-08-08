# frozen_string_literal: true

class CsvValidator
  def initialize(csv_data)
    @csv_data = csv_data
  end

  def valid?
    return false if @csv_data.blank?

    rows = CSV.parse(@csv_data, headers: false)
    column_count = rows.first.size

    rows.each do |row|
      return false if row.size != column_count

      row.each { |cell| return false unless %w[0 1].include?(cell.strip) }
    end

    true
  rescue CSV::MalformedCSVError
    false
  end

  private

  def rows
    CSV.parse(@csv_data, headers: false)
  end
end
