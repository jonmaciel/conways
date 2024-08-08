# frozen_string_literal: true

class CreateCells < ActiveRecord::Migration[7.1]
  def change
    create_table :cells do |t|
      t.references :generation, null: false, foreign_key: true

      t.integer :y, null: false
      t.integer :x, null: false
      t.boolean :alive, null: false

      t.timestamps

      t.index %i[generation_id x y], unique: true
    end
  end
end
