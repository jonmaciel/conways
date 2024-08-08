# frozen_string_literal: true

class CreateBoards < ActiveRecord::Migration[7.1]
  def change
    create_table :boards do |t|
      t.integer :attempts_count, default: 0, null: false

      t.timestamps
    end
  end
end
