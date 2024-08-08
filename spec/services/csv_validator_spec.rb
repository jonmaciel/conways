# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CsvValidator do
  describe '#valid?' do
    let(:valid_csv) { "1,0,0\n0,1,0\n0,0,1\n" }
    let(:empty_csv) { '' }
    let(:malformed_csv) { "1,0,0\n0,1,0\n0,0\n" }
    let(:different_column_count_csv) { "1,0\n0,1,0\n" }
    let(:invalid_value_csv) { "1,0,0\n2,1,0\n" }

    it 'returns true for a valid CSV' do
      validator = CsvValidator.new(valid_csv)
      expect(validator.valid?).to be true
    end

    it 'returns false for an empty CSV' do
      validator = CsvValidator.new(empty_csv)
      expect(validator.valid?).to be false
    end

    it 'returns false for a malformed CSV' do
      validator = CsvValidator.new(malformed_csv)
      expect(validator.valid?).to be false
    end

    it 'returns false for rows with different column counts' do
      validator = CsvValidator.new(different_column_count_csv)
      expect(validator.valid?).to be false
    end

    it 'returns false for invalid values' do
      validator = CsvValidator.new(invalid_value_csv)
      expect(validator.valid?).to be false
    end
  end
end
