# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BoardsController, type: :controller do
  describe 'POST #create' do
    let(:file) { fixture_file_upload('board.csv', 'text/csv') }
    let(:invalid_file) { fixture_file_upload('invalid.csv', 'text/csv') }

    context 'with valid parameters' do
      before do
      end

      it 'creates a new Generation and returns its id' do
        post :create, params: { file: }

        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:created)
        expect(json_response['id']).to eq(Board.last.id)
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
