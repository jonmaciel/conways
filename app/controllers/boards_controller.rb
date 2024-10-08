# frozen_string_literal: true

class BoardsController < ApplicationController
  before_action :validate_csv, only: [:create]

  def index
    render json: Board.all
  end

  def show
    board = Board.find(params[:id])

    render json: { board: }
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Board not found' }, status: :not_found
  end

  def create
    board = Board.new

    GenerationParserService.new(csv_data, board).call

    if board.save
      render json: { board: }, status: :created
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
