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
    # The game is considered over if all cells in the last generation are dead.
    return true if all_cells_dead?

    # The game is also considered over if the maximum number of allowed attempts has been reached.
    return true if max_attempts_reached?

    # Check if the current generation is stable (no changes).
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
    # If there is only one generation, it cannot be stable

    return false if generations.size < 2

    current_gen_cells = generation_cells(generations.last)
    previous_gen_cells = generation_cells(generations[-2])

    # The game is stable if the current generation cells match the previous generation cells
    current_gen_cells == previous_gen_cells
  end

  def generation_cells(generation)
    generation.cells.map { |cell| [cell.x, cell.y, cell.alive] }
  end
end
