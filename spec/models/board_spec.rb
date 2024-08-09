# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Board, type: :model do
  let(:board) { create(:board, :three_by_three) }

  describe '#last_generation' do
    before do
      create(:generation, board:, generation_number: 2)
      create(:generation, board:, generation_number: 3)
    end

    subject { board.last_generation }

    it { is_expected.to eq(board.generations.last) }
  end

  describe '#game_over?' do
    let(:last_generation) { board.last_generation }

    subject { board.reload.game_over? }

    it { is_expected.to be false }

    context 'when all cells are dead' do
      before { last_generation.cells.each { |cell| cell.update!(alive: false) } }

      it { is_expected.to be true }
    end

    context 'when reach the max number of attempts' do
      before { board.update(attempts_count: Board::MAX_ATTEMPTS) }

      it { is_expected.to be true }
    end

    describe '#check_stability?' do
      let(:board) { create(:board) }
      let(:generation_one) { create(:generation, board:) }
      let(:generation_two) { create(:generation, board:, generation_number: 2) }

      context 'when both generations are identical' do
        before do
          create(:cell, generation: generation_one, x: 0, y: 0, alive: true)
          create(:cell, generation: generation_one, x: 0, y: 1, alive: false)

          create(:cell, generation: generation_two, x: 0, y: 0, alive: true)
          create(:cell, generation: generation_two, x: 0, y: 1, alive: false)
        end

        it { is_expected.to be true }
      end

      context 'when generations are different' do
        before do
          create(:cell, generation: generation_one, x: 0, y: 0, alive: true)
          create(:cell, generation: generation_one, x: 0, y: 1, alive: false)

          create(:cell, generation: generation_two, x: 0, y: 0, alive: false)
          create(:cell, generation: generation_two, x: 0, y: 1, alive: true)
        end

        it { is_expected.to be false }
      end

      context 'when there is only one generation' do
        before { create(:cell, generation: generation_one, x: 0, y: 0, alive: true) }

        it { is_expected.to be false }
      end
    end
  end
end
