# frozen_string_literal: true

class Generation < ApplicationRecord
  belongs_to :board
  has_many :cells, dependent: :destroy

  validates :generation_number, presence: true

  def as_json
    {
      id:,
      generation_number:,
      cells:
    }
  end

  def next_generations(number_of_generations = 1)
    return self if board.game_over?

    Generation.transaction do
      (1..number_of_generations).inject(self) do |last_generation, _|
        new_generation = last_generation.dup
        new_generation.generation_number += 1
        new_generation_state(new_generation, last_generation)
        new_generation.save!

        board.increment!(:attempts_count)

        break new_generation if board.game_over?

        new_generation
      end
    end
  end

  private

  def new_generation_state(new_generation, last_generation)
    Generation.transaction do
      new_generation.save!

      last_generation.cells.find_each do |cell|
        new_generation.cells.create!(
          x: cell.x, y: cell.y, alive: next_cell_state(cell)
        )
      end
      add_new_born_cells(new_generation, last_generation)
    end
  end

  def next_cell_state(cell)
    live_neighbors = cells.where(x: (cell.x - 1)..(cell.x + 1), y: (cell.y - 1)..(cell.y + 1), alive: true)
                          .where.not(id: cell.id).count

    return [2, 3].include?(live_neighbors) if cell.alive

    live_neighbors == 3
  end

  def add_new_born_cells(new_generation, last_generation)
    potential_new_cells(last_generation).each do |coordinates|
      x, y = coordinates
      live_neighbors = last_generation.cells.where(x: (x - 1)..(x + 1), y: (y - 1)..(y + 1), alive: true)
                                      .where.not(x:, y:).count

      new_generation.cells.find_or_create_by!(x:, y:, alive: true) if live_neighbors == 3
    end
  end

  def potential_new_cells(last_generation)
    potential_cells = Set.new
    last_generation.cells.find_each do |cell|
      (-1..1).each do |dx|
        (-1..1).each do |dy|
          next if dx.zero? && dy.zero?

          potential_cells.add([cell.x + dx, cell.y + dy]) unless dx.zero? && dy.zero?
        end
      end
    end

    potential_cells
  end
end
