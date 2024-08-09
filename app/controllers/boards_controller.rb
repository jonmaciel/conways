# frozen_string_literal: true

class BoardsController < ApplicationController
  before_action :validate_csv, only: [:create]

  def create
    board = Board.new

    GenerationParserService.new(csv_data, board).call

    if board.save
      render json: { id: board.id }, status: :created
    else
      render json: { errors: board.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def validate_csv
    return if CsvValidator.new(csv_data).valid?

    render json: { error: 'Invalid CSV file' }, status: :bad_request
  end

  def csv_data
    @csv_data ||= params[:file]&.read
  end
end
