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

  describe '#next_generations' do
    subject(:next_gen) { generation.next_generations }

    it 'creates a new generation with incremented generation_number' do
      expect(next_gen.generation_number).to eq(generation.generation_number + 1)
    end

    it 'rolls back if saving new generation fails' do
      allow_any_instance_of(Cell).to receive(:save!).and_raise(ActiveRecord::RecordInvalid)

      expect { generation.next_generations }.to raise_error(ActiveRecord::RecordInvalid)
      expect { generation.reload }.to change { generation.cells.count }.by(0)
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

    context 'when it jumps more than 1 generation' do
      let(:number_of_generations) { rand(2..10) }

      it 'creates the generations' do
        expect do
          generation.next_generations(number_of_generations)
        end.to change { Generation.count }.by(number_of_generations)
      end

      it 'creates the last generation with incremented generation_number' do
        last_generation = generation.next_generations(number_of_generations)

        expect(last_generation.generation_number).to eq(generation.generation_number + number_of_generations)
      end
    end

    context 'when game overs before the number of attempts is reached' do
      let(:number_of_generations) { Board::MAX_ATTEMPTS + 1 }

      before { generation.next_generations(number_of_generations) }

      it 'creates les genearions than the max of attempts' do
        expect(board.reload.generations.count).to be < number_of_generations
      end
    end

    context 'when the game is over' do
      before { expect(board).to receive(:game_over?).and_return(true) }

      it { is_expected.to eq(generation) }

      it "doesn't create any generations" do
        expect { generation.next_generations }.to change { Generation.count }.by(0)
      end
    end
  end

  describe '#visual_representation' do
    it 'returns correct visual representation' do
      expected_output = "1 1 1\n1 1 1"
      expect(generation.visual_representation).to eq(expected_output)
    end
  end
end
