# frozen_string_literal: true

class Generation < ApplicationRecord
  belongs_to :board
  has_many :cells, dependent: :destroy

  validates :generation_number, presence: true

  def as_json
    {
      id:,
      generation_number:,
      cells:,
      visual_representation:
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

  # Generates a visual representation of the generation using '0' and '1'
  def visual_representation
    # Initializes an empty grid based on the minimum and maximum coordinates of the cells
    grid =
      Array.new(max_y - min_y + 1) { Array.new(max_x - min_x + 1, '0') }

    fill_grid_with_cells(grid)
    format_grid_as_string(grid)
  end

  private

  def min_x
    @min_x ||= cells.minimum(:x) || 0
  end

  def min_y
    @min_y ||= cells.minimum(:y) || 0
  end

  def max_x
    @max_x ||= cells.maximum(:x) || 0
  end

  def max_y
    @max_y ||= cells.maximum(:y) || 0
  end

  # Fills the grid with '1' for alive cells and '0' for dead cells
  def fill_grid_with_cells(grid)
    cells.each do |cell|
      x = cell.x - min_x
      y = cell.y - min_y

      grid[y][x] = cell.alive ? '1' : '0'
    end
  end

  # Formats the grid into a string representation for easy visualization
  def format_grid_as_string(grid)
    grid.map { |row| row.join(' ') }.join("\n")
  end

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
    # Count the number of alive neighbors around the given cell
    live_neighbors = cells.where(x: (cell.x - 1)..(cell.x + 1), y: (cell.y - 1)..(cell.y + 1), alive: true)
                          .where.not(id: cell.id).count

    # Determine the next state of the cell based on the number of alive neighbors
    # If the cell is alive, it remains alive if it has 2 or 3 alive neighbors
    # If the cell is dead, it becomes alive if it has exactly 3 alive neighbors
    return [2, 3].include?(live_neighbors) if cell.alive

    live_neighbors == 3
  end

  def add_new_born_cells(new_generation, last_generation)
    # Get potential new cell coordinates based on the last generation's cells
    potential_new_cells(last_generation).each do |coordinates|
      x, y = coordinates

      # Count the number of alive neighbors for the potential new cell
      live_neighbors = last_generation.cells.where(x: (x - 1)..(x + 1), y: (y - 1)..(y + 1), alive: true)
                                      .where.not(x:, y:).count

      # Create a new cell in the new generation if it has exactly 3 alive neighbors
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
