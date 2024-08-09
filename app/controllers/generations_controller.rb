# frozen_string_literal: true

class GenerationsController < ApplicationController
  before_action :set_board, only: %i[index show next_generation]

  def index
    render json: { generations: @board.generations }, status: :ok
  end

  def show
    render json: { generation: @board.generations.find(params[:id]) }, status: :ok
  end

  def next_generation
    generation = @board.generations.last
    next_gen = generation.next_generations(params[:number_of_generations]&.to_i || 1)

    if next_gen.save
      render json: { board: @board }, status: :created
    else
      render json: { error: generation.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_board
    @board ||= Board.find(params[:board_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Board not found' }, status: :not_found
  end
end
