# frozen_string_literal: true

class Board < ApplicationRecord
  MAX_ATTEMPTS = 50

  has_many :generations, dependent: :destroy

  def as_json(*_args)
    {
      id:,
      last_generation:,
      attempts_count:,
      game_over: game_over?,
      created_at:
    }
  end

  def last_generation
    generations.last
  end

  def game_over?
    return true if all_cells_dead? || max_attempts_reached?

    check_stability?
  end

  private

  def all_cells_dead?
    last_generation.cells.none?(&:alive)
  end

  def max_attempts_reached?
    attempts_count >= MAX_ATTEMPTS
  end

  def check_stability?
    return false if generations.count < 2

    current_gen = generations.last
    previous_gen = generations[-2]

    current_gen.cells.map { |cell| [cell.x, cell.y, cell.alive] } ==
      previous_gen.cells.map { |cell| [cell.x, cell.y, cell.alive] }
  end
end
