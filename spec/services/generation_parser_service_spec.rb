# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GenerationParserService do
  describe '#call' do
    let(:csv_data) do # 3x3 board
      <<~CSV
        1,0,1
        0,1,0
        1,0,1
      CSV
    end

    let(:board) { create(:board) }
    let(:builder) { described_class.new(csv_data, board) }

    it 'creates a new generation from the CSV data' do
      generation = builder.call

      expect(generation).to be_a(Generation)
      expect(generation.board).to eq(board)
      expect(generation.cells.size).to eq(9)
      expect(generation.generation_number).to eql(1)
      expect(generation.valid?).to be(true)

      expect(generation.cells.map(&:alive)).to match_array [true, false, true, false, true, false, true, false, true]
    end

    it 'correctly creates cells with their coordinates' do
      generation = builder.call
      cells = generation.cells

      index = 0

      (0...3).each do |y|
        (0...3).each do |x|
          cell = cells[index]

          expect(cell.y).to eq(y)
          expect(cell.x).to eq(x)

          index += 1
        end
      end
    end
  end
end
