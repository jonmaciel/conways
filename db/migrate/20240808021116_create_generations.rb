# frozen_string_literal: true

class CreateGenerations < ActiveRecord::Migration[7.1]
  def change
    create_table :generations do |t|
      t.references :board, null: false, foreign_key: true
      t.integer :generation_number

      t.index %i[board_id generation_number], unique: true

      t.timestamps
    end
  end
end
