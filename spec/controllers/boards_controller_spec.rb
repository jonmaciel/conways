# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BoardsController, type: :controller do
  describe 'GET #index' do
    it 'returns a list of all boards' do
      create_list(:board, 3, :three_by_three)

      get :index

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end

  describe 'GET #show' do
    let(:board) { create(:board, :three_by_three) }

    it 'returns a board' do
      get :show, params: { id: board.id }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['board']['id']).to eq(board.id)
    end

    it 'returns an error if the board does not exist' do
      get :show, params: { id: -1 }

      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST #create' do
    let(:file) { fixture_file_upload('board.csv', 'text/csv') }
    let(:invalid_file) { fixture_file_upload('invalid.csv', 'text/csv') }

    context 'with valid parameters' do
      it 'creates a new Generation and returns its id' do
        post :create, params: { file: }

        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:created)
        expect(json_response['board']['id']).to eq(Board.last.id)
        expect(json_response['board']['last_generation']['id']).to eq(Generation.last.id)
      end

      it 'create the whole board' do
        expect do
          post :create, params: { file: }
        end.to change(Board, :count).by(1)
                                    .and change(Generation, :count).by(1)
                                                                   .and change(Cell, :count).by(9)
      end
    end

    context 'with invalid parameters' do
      it 'returns an error if no file is uploaded' do
        post :create, params: {}

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['error']).to eq('Invalid CSV file')
      end

      it 'returns error if the csv is invalid' do
        post :create, params: { file: invalid_file }

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['error']).to eq('Invalid CSV file')
      end
    end
  end
end
