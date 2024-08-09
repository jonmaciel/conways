# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GenerationsController, type: :controller do
  describe 'POST #next_generation' do
    let(:board) { create(:board, :three_by_three) }
    let(:generation) { board.generations.first }

    context 'with existing generation' do
      it 'creates the next generation and returns its id' do
        post :next_generation, params: { board_id: board.id }

        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:created)
        expect(json_response['id']).to eq(Generation.last.id)
      end
    end

    context 'when the next generation cannot be saved' do
      it 'returns an error if unable to create next generation' do
        allow_any_instance_of(Generation).to receive(:save).and_return(false)

        post :next_generation, params: { board_id: board.id }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'with invalid board id' do
      it 'returns an error if the board does not exist' do
        post :next_generation, params: { board_id: -1 }

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
