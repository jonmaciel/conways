# frozen_string_literal: true

class GenerationParserService
  def initialize(csv_data, board)
    @csv_data = csv_data
    @board = board
  end

  def call
    parse
  end

  private

  attr_reader :board

  def parse
    CSV.parse(@csv_data.strip, headers: false).each_with_index do |row, y|
      row.each_with_index do |cell_state, x|
        alive = (cell_state.strip == '1')

        generation.cells.build(x:, y:, alive:)
      end
    end

    generation
  end

  def generation
    @generation ||= board.generations.build(generation_number: 1)
  end
end
