# frozen_string_literal: true

class Board < ApplicationRecord
  MAX_ATTEMPTS = 50

  has_many :generations, dependent: :destroy

  default_scope { order(id: :desc) }

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
    return false if generations.size < 2

    current_gen_cells = generation_cells(generations.last)
    previous_gen_cells = generation_cells(generations[-2])

    current_gen_cells == previous_gen_cells
  end

  def generation_cells(generation)
    generation.cells.map { |cell| [cell.x, cell.y, cell.alive] }
  end
end
