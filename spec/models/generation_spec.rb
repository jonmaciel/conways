# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Generation, type: :model do
  let(:board) { create(:board) }
  let(:generation) { create(:generation, board:) }

  before do
    [
      { x: 0, y: 0, alive: true },
      { x: 0, y: 1, alive: true },
      { x: 1, y: 0, alive: true },
      { x: 1, y: 1, alive: true },
      { x: 2, y: 0, alive: true },
      { x: 2, y: 1, alive: true }
    ].each do |attrs|
      create(:cell, generation:, **attrs)
    end
  end

  it 'is valid with valid attributes' do
    expect(generation).to be_valid
  end

  it 'belongs to a board' do
    expect(generation.board).to eq(board)
  end

  it 'has many cells' do
    expect(generation.cells.count).to eq(6)
  end

  describe '#next_generation' do
    let(:next_gen) { generation.next_generation }

    it 'creates a new generation with incremented generation_number' do
      expect(next_gen.generation_number).to eq(generation.generation_number + 1)
    end

    it 'keeps cells with two or three live neighbors alive' do
      cell = next_gen.cells.find_by(x: 0, y: 0)
      expect(cell.alive).to be(true)
    end

    it 'kills cells with fewer than two live neighbors' do
      cell = next_gen.cells.find_by(x: 1, y: 1)
      expect(cell.alive).to be(false)
    end

    it 'kills cells with more than three live neighbors' do
      cell = next_gen.cells.find_by(x: 1, y: 1)
      expect(cell.alive).to be(false)
    end

    it 'brings to life cells with exactly three live neighbors' do
      cell = next_gen.cells.find_by(x: 1, y: 2)
      expect(cell.alive).to be(true)
    end
  end
end
